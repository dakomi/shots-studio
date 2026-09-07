# Gemma 4 LiteRT-LM Support

Shots Studio `1.9.103` adds first-class support for **Gemma 4 `.litertlm`** model files in the on-device AI flow requested in issue [#204](https://github.com/AnsahMohammad/shots-studio/issues/204).

## What changed

- The on-device Gemma loader now recognizes **`.litertlm`** files and routes them through the LiteRT-LM path instead of treating them like legacy `.task` bundles.
- Gemma 4 model files are identified automatically and loaded with the correct Gemma 4 model type.
- The built-in download button now targets the recommended **Gemma 4 E2B IT** LiteRT-LM build.
- Manual sideloading now explicitly supports `.litertlm`, `.task`, and `.bin` model files from AI Settings.

## Recommended model

- **Model:** `gemma-4-E2B-it.litertlm`
- **Size:** about `2.4GB`
- **Source:** <https://huggingface.co/litert-community/gemma-4-E2B-it-litert-lm>

## Notes

- Older Gemma `.task` models still work for users who want to keep the legacy format.
- CPU mode remains the safest default for broad device compatibility; GPU mode is still available from AI Settings.
- Users who want a larger local model can manually sideload a compatible Gemma 4 `.litertlm` file such as an E4B build.
