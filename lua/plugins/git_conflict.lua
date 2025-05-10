-- PLUGIN: The 'git-conflict.nvim' plugin provides visualise and resolve functionalty.
return {
  'akinsho/git-conflict.nvim', version = "*", config = true
}
-- NOTE: This plugin offers default buffer local mappings inside conflicted files.
-- co — choose ours
-- ct — choose theirs
-- cb — choose both
-- c0 — choose none
-- ]x — move to previous conflict
-- [x — move to next conflict
