# AI CLI Studio Installer

Скрипт для автоматического развертывания AI-агентов в Linux (Ubuntu/Debian/RHEL).
Использует изолированную установку в `/opt` для чистоты системы.

## 📦 Что внутри

| CLI Tool | Описание | Путь установки |
|---|---|---|
| **Koda CLI** | Github AI Agent | `/opt/koda` |
| **Qwen CLI** | Qwen Coder (Alibaba) | `/opt/qwen` |
| **Gemini CLI** | Google Gemini Studio | `/opt/gemini` |
| **Codex CLI** | OpenAI Codex | `/opt/codex` |

## 🚀 Как запустить

```bash
git clone https://github.com/YOUR_USERNAME/ai-cli-studio.git
cd ai-cli-studio
chmod +x install.sh
./install.sh
