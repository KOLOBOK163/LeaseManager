# Lease Manager Frontend

Vue 3 frontend для приложения Lease Manager.

## Технологии

- **Vue 3** - прогрессивный JavaScript-фреймворк
- **TypeScript** - типизация
- **Pinia** - управление состоянием
- **Vue Router** - маршрутизация
- **Axios** - HTTP-клиент
- **Bootstrap 5** - стилизация
- **Vite** - сборщик

## Установка

```bash
npm install
```

## Запуск

```bash
npm run dev
```

Приложение будет доступно по адресу: http://localhost:3000

## Сборка

```bash
npm run build
```

## Структура проекта

```
frontend/
├── src/
│   ├── api/           # API клиенты
│   │   ├── axios.ts   # Настройка axios с интерцепторами
│   │   └── auth.ts    # Auth API endpoints
│   ├── assets/        # Статические файлы
│   ├── components/    # Переиспользуемые компоненты
│   ├── router/        # Настройка роутера
│   │   └── index.ts
│   ├── stores/        # Pinia store
│   │   └── auth.ts    # Auth store
│   ├── types/         # TypeScript типы
│   │   └── auth.ts
│   ├── views/         # Страницы приложения
│   │   ├── LoginView.vue
│   │   ├── RegisterView.vue
│   │   └── DashboardView.vue
│   ├── App.vue        # Корневой компонент
│   └── main.ts        # Точка входа
├── index.html
├── package.json
├── tsconfig.json
└── vite.config.ts
```

## Функционал

### Страницы

1. **/login** - Вход в систему
   - Форма входа (username/password)
   - Валидация полей
   - Сохранение JWT токена
   - Перенаправление на dashboard после входа

2. **/register** - Регистрация
   - Форма регистрации
   - Валидация паролей (совпадение, мин. длина)
   - Автоматический вход после регистрации

3. **/dashboard** - Главная страница
   - Доступна только авторизованным
   - Отображение информации о пользователе
   - Кнопка выхода

### Авторизация

- JWT токен сохраняется в localStorage
- Автоматически добавляется к запросам через axios interceptor
- При 401 ошибке - редирект на /login
- Защита роутов через navigation guards

## API Endpoints

| Метод | Endpoint | Описание |
|-------|----------|----------|
| POST | /api/auth/login | Вход |
| POST | /api/auth/register | Регистрация |

## Проксирование API

Vite настроен на проксирование `/api` запросов на `http://localhost:8080`.

Изменить в `vite.config.ts`:
```typescript
server: {
  proxy: {
    '/api': {
      target: 'http://localhost:8080',
      changeOrigin: true
    }
  }
}
```
