return {
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = '',
      },
      schemas = require('schemastore').yaml.schemas(),
      validate = true,
      completion = true,
      hover = true,
    },
  },
}
