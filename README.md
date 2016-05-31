# IQ300 Frontend
------

## Старт

Должны быть установлены git, ruby, bundler, bower, nodejs.
Работает с nodejs v0.10.32.
Удобно пользоваться [nvm](https://github.com/creationix/nvm) — `nvm use` устанавливает версию node, прописанную в `.nvmrc`

1. `bundle install`

2. `./frontend_prepare` устанавливаем зависимости

3. Запуск сервера

`npm run server`

4. Билд статичного сайта
  `./frontend_build` делает билд статичного сайта в `build/` и билд
компонента в `dist/`

5. Пути к файлам

Gulp-задача собирает в `app/tmp/assets` все ассеты, при билде — в
`dist/assets`. Поэтому во вьюхах фронтэнд-проекта картинки с путями
`/assets/pic.png`, а в стилях `background-image: url("#{$images-path}/logo-blue.png")`

## Деплой статичного проекта

`./frontend_build` — делаем билд

`STAGE=<stage_name> ./frontend_deploy` — деплоим на
`<stage_name>.iq300-dev.ru`, по номеру стейджа предварительно
договариваемся и указываем в STAGE — например, `STAGE=frontend3 ./frontend_deploy`

```
./frontend_build && STAGE=<stage_name> ./frontend_deploy
```

При первом деплое нужно связаться c [elvir](https://github.com/elvir) или
[sibsfinx](https://github.com/sibsfinx) и скинуть свой ssh-ключ.



## Использование в основном проекте

Должен быть настроен Bower (в т.ч. Sprockets для него)

1. Устанавливаем компонент
```bower install --save git@github.com:IQ300Ltd/NewInterfaces.git#master```

2. Подключаем стили в проект
```stylesheet_link_tag "iq300_frontend/app/stylesheets/app"```
```stylesheet_link_tag "iq300_frontend/app/stylesheets/dev-app"```
Не забываем добавлять в `config/application.rb`
```config.assets.precompile += %w(app.css dev-app.css)```
То же для остальных прекомпилируемых стилей.

3. Обновление компонента в рельсовом проекте
```bower update iq300-frontend```

## Примечания

`active_admin.scss` не включён (оставлен в главном проекте)

Всё, что компилируется, находится в `app`.

Билд компонента находится в `dist`.

Билд статичного сайда находится в `build`

Вьюхи можно использовать HAML или ERB (первый предпочтительнее).

По возможности использовать `= partial` (аналог рельсовых `= render`).

Можно копировать разметку страницы из инспектора браузера и
конвертировать в Haml, заменяя повторяющиеся части кода на partial'ы.

Быстрый билд и push в репо `./update_component`


## Troubleshooting

Удаляем кэш node-модулей
```rm -rf node_modules && npm cache clean && npm install```

Пробуем альтернативный репо node-модулей (помогает при fetch-ошибках)
```npm config set registry "https://registry.nodejitsu.com"```
или дефолтный репо
```npm config set registry http://registry.npmjs.org/```

Фиксируем зависимости node-модулей
```npm shrinkwrap```

## TODO

- Убрать зависимости из проекта в Bower `grep -r TODO app`
- Обновить libsass
