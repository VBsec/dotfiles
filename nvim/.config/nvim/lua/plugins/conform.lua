return {
    "stevearc/conform.nvim",
    opts = {
        formatters_by_ft = {
            markdown = { "prettier" },
            ["markdown.mdx"] = { "prettier" },
        },
        formatters = {
            prettier = {
                -- Use project's prettier config if available
                require_cwd = false,
            },
        },
    },
}
