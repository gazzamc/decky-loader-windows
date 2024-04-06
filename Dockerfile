# Pull Decky Loader Release
FROM node:18.18.0 as frontend-stage
ARG release
RUN git clone --branch $release https://github.com/SteamDeckHomebrew/decky-loader.git /app

# Build Frontend
WORKDIR app/frontend

RUN echo $release > .loader.version
RUN npm i -g pnpm
RUN pnpm i
RUN pnpm run build

# Build EXE
FROM ghcr.io/batonogov/pyinstaller-windows:v4.2.7 as build-bin-stage

COPY --from=frontend-stage app/backend /src/
COPY --from=frontend-stage app/plugin /src/plugin
COPY --from=frontend-stage app/backend/requirements.txt /src/requirements.txt
COPY --from=frontend-stage app/frontend/.loader.version /src/dist/.loader.version

WORKDIR /src

RUN pip install -r requirements.txt

RUN pyinstaller --noconfirm --onefile --name "PluginLoader" \
    --add-data "/src/static;static" --add-data "/src/locales;locales" \
    --add-data "/src/src/legacy;src/legacy" --add-data "/src/plugin;plugin" \
    --hidden-import=logging.handlers --hidden-import=sqlite3 /src/main.py

RUN pyinstaller --noconsole --noconfirm --onefile --name "PluginLoader_noconsole" \
    --add-data "/src/static;static" --add-data "/src/locales;locales" \
    --add-data "/src/src/legacy;src/legacy" --add-data "/src/plugin;plugin" \
    --hidden-import=logging.handlers --hidden-import=sqlite3 /src/main.py

# Copy Binaries to host
FROM scratch
COPY --from=build-bin-stage /src/dist ./dist/homebrew
