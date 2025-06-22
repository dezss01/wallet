FROM --platform=linux/arm64 node:20-alpine

# Устанавливаем рабочую директорию
WORKDIR /frontend/base_front

# Устанавливаем необходимые системные зависимости
# RUN apk add --no-cache python3 make g++ git

# Копируем только package.json и yarn.lock для кэширования зависимостей
COPY package.json yarn.lock ./

# Очищаем кэш и принудительно устанавливаем зависимости
RUN yarn cache clean && \
  yarn config set ignore-platform true && \
  yarn install --frozen-lockfile

# Копируем все остальные файлы проекта
COPY . .

# Открываем порт для Vite
EXPOSE 5173

# Команда для запуска dev-сервера
CMD ["yarn", "dev", "--host", "0.0.0.0"]
