# IQ300 Frontend
------

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

Билд находится в `dist`.

Вьюхи можно использовать HAML или ERB (первый предпочтительнее).

По возможности использовать `= partial` (аналог рельсовых `= render`).

Можно копировать разметку страницы из инспектора браузера и
конвертировать в Haml, заменяя повторяющиеся части кода на partial'ы.

Быстрый билд и push в репо `./update_component`


## Разработка

`bundle install`

`bower install`

`bundle exec middleman` starts a server on `0.0.0.0:4567` (liveupdate included).

`bundle exec middleman build` builds a static site in `build` folder.

## TODO

Перенести из главного проекта все изменения после 30 июля.

Убрать зависимости из проекта в Bower.

`grep -r TODO app`
