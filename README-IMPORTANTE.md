# Estado de deploy — video-automatico-youtube

## Bloqueio encontrado

A branch `main` contém somente arquivos de configuração e `automate-clipping-main-configured.zip`. As pastas `backend/` e `web/` não estão na raiz do repositório. Portanto, o `docker-compose.yml` referencia `backend/Dockerfile`, mas esse caminho não existe e o build não inicia.

## Correção necessária

Extraia o conteúdo do ZIP para a raiz do repositório de forma que a estrutura fique assim:

- `backend/Dockerfile`
- `backend/app/`
- `backend/requirements.txt`
- `web/package.json`
- `web/src/`
- `docker-compose.yml`

Não mantenha só o arquivo ZIP. Preserve os arquivos de configuração existentes e não envie `.env` nem credenciais.

## Autopilot

O `.env.example` mantém `EDGETAPE_AUTOPILOT_ENABLED=0` por segurança. Antes de ativar, configure `EDGETAPE_YOUTUBE_API_KEY`, `EDGETAPE_AUTOPILOT_OWNER_ID`, JWT forte, DB protegido e OAuth das redes sociais. A rotina só deve processar fontes com licença Creative Commons confirmada pela API oficial; essa licença ainda precisa ser validada para o uso planejado, inclusive direitos de imagem/áudio de terceiros. As plataformas podem exigir revisão/aprovação de apps e impor limites.

Não é possível considerar o deploy pronto enquanto as pastas do app não estiverem no repositório e não forem realizados build/testes no servidor.