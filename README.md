# IQ300 Frontend
------

## Использование в основном проекте

Должен быть настроен Bower (в т.ч. Sprockets для него)

1. Устанавливаем компонент
```bower install iq300_frontend git@github.com:IQ300Ltd/NewInterfaces.git```

2. Подключаем стили в проект
```@import iq300_frontend/app/stylesheets/application.css.scss```

## Примечания

`active_admin.scss` не включён (оставлен в главном проекте)

Всё, что компилируется, находится в `app`.

В `assets` нужно держать то, что компилируется с помощью рельс и (на
данный момент) не подключено с помощью относительных ссылок — например,
картинки, на которые ссылаются стили.

По возможности использовать `= partial` (аналог рельсовых `= render`).

Необходимые правки только для статического проекта держим в
`stylesheets/static_fixes` — они не подключаются в основной проект.

## Development

`bundle install` first.

`bundle exec middleman` starts a server on `0.0.0.0:4567` (liveupdate included).

`bundle exec middleman build` builds a static site in `build` folder.

