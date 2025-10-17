local jdtls = require("jdtls")

local bundles = {
	vim.fn.glob("~/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
}

vim.list_extend(bundles, vim.split(vim.fn.glob("~/.local/share/nvim/mason/share/java-test/*.jar", 1), "\n"))

return {
	on_attach = function(client, bufnr)
    jdtls.setup_dap({ hotcodereplace = "auto" })
    require("jdtls.dap").setup_dap_main_class_configs()
	end,
	cmd = {
		"java",
		"-Declipse.application=org.eclipse.jdt.ls.core.id1",
		"-Dosgi.bundles.defaultStartLevel=4",
		"-Declipse.product=org.eclipse.jdt.ls.core.product",
		"-Dlog.protocol=true",
		"-Dlog.level=ALL",
		"-Xmx1g",
		"--add-modules=ALL-SYSTEM",
		"--add-opens",
		"java.base/java.util=ALL-UNNAMED",
		"--add-opens",
		"java.base/java.lang=ALL-UNNAMED",
		"-javaagent:" .. vim.fn.expand("$HOME/.local/share/nvim/mason/share/jdtls/lombok.jar"),
		-- "-agentlib:jdwp=transport=dt_socket,address=5005,server=y,suspend=n",
		"-jar",
		vim.fn.expand(
			"$HOME/.local/share/nvim/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_1.6.900.v20240613-2009.jar"
		),
		"-configuration",
		vim.fn.expand("$HOME/.local/share/nvim/mason/packages/jdtls/config_linux"),
		"-data",
		vim.fn.expand("$HOME/.cache/jdtls/workspace"),
	},
	root_dir = vim.fs.dirname(vim.fs.find({ "gradlew", "mvnw", ".git" }, { upward = true })[1]),
	filetypes = { "java" },
	init_options = {
		bundles = bundles,
	},
	settings = {
		java = {
			home = "/usr/lib/jvm/java-21-openjdk",
			eclipse = {
				downloadSources = true,
			},
			configuration = {
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = "/usr/lib/jvm/java-8-openjdk-amd64",
					},
					{
						name = "JavaSE-11",
						path = "/usr/lib/jvm/java-11-openjdk",
					},
					{
						name = "JavaSE-17",
						path = "/usr/lib/jvm/java-17-openjdk",
					},
					{
						name = "JavaSE-21",
						path = "/usr/lib/jvm/java-21-openjdk",
						default = true,
					},
				},
			},
			project = {
				referencedLibraries = {
					vim.fn.expand("$HOME/.m2/repository/**/*.jar"),
				},
			},
			compilation = {
				annotationProcessing = { enabled = true },
			},
		},
	},
}
