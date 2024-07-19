ollamaupdate() {
# Array of models
models=(
    "mistral"
    "internlm2"
    "starcoder2:3b"
    "llava-phi3"
    "gemma2"
    "mxbai-embed-large"
    "nomic-embed-text"
    "phi3:mini"
    "qwen2:0.5b"
    "qwen2"
    "qwen2:1.5b"
    "starcoder2"
    "tinydolphin"
    "dolphin-mistral"
    "llama3"
    "moondream"
)

# Loop through each model
for model in "${models[@]}"; do
    # Run the command with the current model
    ollama pull "$model"

    # Check if the command was successful
    if [ $? -ne 0 ]; then
        echo "Failed to pull model: $model"
        exit 1
    fi
done

echo "All models updated successfully."
}
