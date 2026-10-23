# Estado de deploy — video-automatico-youtube

## Correções aplicadas

- Criado um `Dockerfile` na raiz do repositório.
- Atualizado o `docker-compose.yml` para construir as imagens usando o Dockerfile raiz.
- O build extrai `automate-clipping-main-configured.zip` durante a construção e compila o frontend/backend sem exigir extração manual no GitHub.

A raiz ainda mantém o código da aplicação dentro do ZIP; `backend/` e `web/` não estão versionados individualmente. Por isso, a construção precisa ser testada em Docker real antes de considerar o deploy validado.

## Autopilot 24/7

O `.env.example` mantém `EDGETAPE_AUTOPILOT_ENABLED=0` por segurança. Antes de ativar, configure `EDGETAPE_YOUTUBE_API_KEY`, `EDGETAPE_AUTOPILOT_OWNER_ID`, um JWT forte, banco de dados protegido e OAuth das redes sociais. A rotina busca fontes Creative Commons confirmadas pela API oficial, mas ainda é necessário verificar os direitos de reutilização para o uso pretendido, inclusive áudio/imagem de terceiros. Plataformas podem exigir revisão dos aplicativos e impor limites de publicação.

## Como validar

Na máquina de deploy, criar um `.env` com segredos reais (não versionar esse arquivo) e executar:

```bash
docker compose config
docker compose build
docker compose up -d
docker compose ps
docker compose logs --tail=100 api worker autopilot
```

Manter `EDGETAPE_AUTOPILOT_ENABLED=0` até a API, banco, worker, contas OAuth e configuração da fonte terem sido verificados. A configuração de autopilot deve ser habilitada somente depois dos testes e confirmações necessários.
