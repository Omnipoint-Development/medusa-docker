import { loadEnv, defineConfig } from "@medusajs/framework/utils"

loadEnv(process.env.NODE_ENV || "development", process.cwd())

module.exports = defineConfig({
  projectConfig: {
    // ... other config
    databaseDriverOptions: {
      ssl: false,
      sslmode: "disable",
    },
  },
})
