local jdtls = require("jdtls")

local system = vim.loop.os_uname().sysname
local CONFIG
if system == "Linux" then
	CONFIG = "config_linux"
elseif system == "Darwin" then
	CONFIG = "config_mac"
else
	CONFIG = "config_win"
end

local HOME = vim.fn.expand("$HOME")
local MASON = HOME .. "/.local/share/nvim/mason"
local JDTLS_PATH = MASON .. "/packages/jdtls"
local LOMBOK = MASON .. "/share/jdtls/lombok.jar"

local launcher_path = vim.fn.glob(JDTLS_PATH .. "/plugins/org.eclipse.equinox.launcher_*.jar")

local bundles = {
	vim.fn.glob("~/.local/share/nvim/mason/share/java-debug-adapter/com.microsoft.java.debug.plugin.jar"),
}

vim.list_extend(bundles, vim.split(vim.fn.glob(MASON .. "/share/java-test/*.jar", 1), "\n"))

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
		"-javaagent:" .. LOMBOK,
		"-jar",
		launcher_path,
		"-configuration",
		JDTLS_PATH .. "/" .. CONFIG,
		"-data",
		HOME .. "/.cache/jdtls/workspace",
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
				runtimes = (function()
					if system == "Darwin" then
						return {
							{
								name = "JavaSE-1.8",
								path = "/Library/Java/JavaVirtualMachines/openjdk-8.jdk/Contents/Home",
							},
							{
								name = "JavaSE-11",
								path = "/Library/Java/JavaVirtualMachines/openjdk-11.jdk/Contents/Home",
							},
							{
								name = "JavaSE-17",
								path = "/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home",
							},
							{
								name = "JavaSE-21",
								path = "/Library/Java/JavaVirtualMachines/openjdk-21.jdk/Contents/Home",
								default = true,
							},
						}
					elseif system == "Linux" then
						return {
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
						}
					else
						return {} -- Manual Windows configuration needed.
					end
				end)(),
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
