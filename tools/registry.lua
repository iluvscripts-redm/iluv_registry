local REGISTRY_URL = "https://raw.githubusercontent.com/iluvscripts-redm/iluv_registry/main/scripts/%s/manifest.json"

AddEventHandler("onResourceStart", function(resourceName)
	if resourceName ~= GetCurrentResourceName() then
		return
	end

	local version = GetResourceMetadata(resourceName, "version", 0) or "0.0.0"
	local script = resourceName:gsub("^iluv_", "")

	PerformHttpRequest(REGISTRY_URL:format(script), function(status, body)
		if status ~= 200 then
			print(("[^1Iluv Scripts^7] Failed to check '%s' (HTTP %s)"):format(script, status))
			return
		end

		local manifest = json.decode(body)

		if not manifest or not manifest.version then
			print(("[^1Iluv Scripts^7] Invalid manifest for '%s'"):format(script))
			return
		end

		if manifest.version == version then
			print(("[^2Iluv Scripts^7] '%s' is up to date (v%s)"):format(script, version))
			return
		end

		print(("[^3Iluv Scripts^7] Update available for '%s': v%s → v%s"):format(
			script,
			version,
			manifest.version
		))
	end, "GET")
end)
