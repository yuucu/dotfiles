#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const readline = require('readline');

// ANSI color codes
const colors = {
  reset: '\x1b[0m',
  blue: '\x1b[34m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  red: '\x1b[31m',
  cyan: '\x1b[36m',
  gray: '\x1b[90m',
};

// Read JSON input from stdin
let inputData = '';
process.stdin.on('data', (chunk) => {
  inputData += chunk;
});

process.stdin.on('end', async () => {
  try {
    const input = JSON.parse(inputData);
    const statusLine = await buildStatusLine(input);
    console.log(statusLine);
  } catch (error) {
    console.log('Status line error');
  }
});

async function buildStatusLine(input) {
  // Extract basic info
  const model = input.model?.display_name || input.model?.id || '-';
  const cost = input.cost?.total_cost_usd;
  const duration = input.cost?.total_duration_ms;
  const transcriptPath = input.transcript_path;

  // Get token usage from transcript
  const tokenInfo = await getTokenUsage(transcriptPath);

  // Format values
  const costDisplay = cost != null ? `$${cost.toFixed(4)}` : '-';
  const durationDisplay = duration != null ? `${(duration / 1000).toFixed(1)}s` : '-';

  // Build status line
  const parts = [
    `${colors.blue}󰧑 ${model}${colors.reset}`,
    `${colors.gray}|${colors.reset}`,
    tokenInfo.display,
    `${colors.gray}|${colors.reset}`,
    `${colors.yellow}󰊫 ${durationDisplay}${colors.reset}`,
    `${colors.gray}|${colors.reset}`,
    `${colors.green}󰪥 ${costDisplay}${colors.reset}`,
  ];

  return parts.join(' ');
}

async function getTokenUsage(transcriptPath) {
  if (!transcriptPath || !fs.existsSync(transcriptPath)) {
    return {
      display: `${colors.cyan}󰔷 ctx:-${colors.reset}`,
      tokens: 0,
      percentage: 0,
    };
  }

  try {
    const fileStream = fs.createReadStream(transcriptPath);
    const rl = readline.createInterface({
      input: fileStream,
      crlfDelay: Infinity,
    });

    let lastUsage = null;

    for await (const line of rl) {
      try {
        const data = JSON.parse(line);
        // Handle both direct format (data.role) and nested format (data.message.role)
        const role = data.role || data.message?.role;
        const usage = data.usage || data.message?.usage;

        if (role === 'assistant' && usage) {
          lastUsage = usage;
        }
      } catch (e) {
        // Skip invalid JSON lines
      }
    }

    if (!lastUsage) {
      return {
        display: `${colors.cyan}󰔷 ctx:-${colors.reset}`,
        tokens: 0,
        percentage: 0,
      };
    }

    // Calculate total tokens
    const totalTokens =
      (lastUsage.input_tokens || 0) +
      (lastUsage.output_tokens || 0) +
      (lastUsage.cache_creation_input_tokens || 0) +
      (lastUsage.cache_read_input_tokens || 0);

    const maxTokens = 200000;
    const percentage = ((totalTokens / maxTokens) * 100).toFixed(1);

    // Color based on usage
    let color = colors.green;
    if (percentage >= 90) {
      color = colors.red;
    } else if (percentage >= 70) {
      color = colors.yellow;
    }

    const tokensDisplay = formatNumber(totalTokens);

    return {
      display: `${color}󰔷 ${tokensDisplay} (${percentage}%)${colors.reset}`,
      tokens: totalTokens,
      percentage: parseFloat(percentage),
    };
  } catch (error) {
    return {
      display: `${colors.cyan}󰔷 ctx:-${colors.reset}`,
      tokens: 0,
      percentage: 0,
    };
  }
}

function formatNumber(num) {
  if (num >= 1000) {
    return `${(num / 1000).toFixed(1)}k`;
  }
  return num.toString();
}
