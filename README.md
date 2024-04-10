# Verd project
Gem для Rails фреймоврка предназначенный для осуществления поведенческой верификации (Behavioral Verification) пользователя

## Клавиатурный почерк

### Принципы работы

-  представление текста в виде `[['symbol', time_in_ms], ...]`, на основе которого формируется статистическая матрица пользователя, отражающая скорость печати пары символов:
```
    {
        'a' => {
            'b' => 201,
            'c' => 323,
            ...
        },
        ...
    }
```
-  помимо расчета среднего времени перехода от одного символа к другому, рассчитывается среднеквадратичное отклонение от среднего результата;

Результат верификации текста представляет собой статус ответа 0 (отрицательно), 1 (не уверен), 2 (положительно), что отображает процентную характеристику. Для получение процентного показателя сравнения двух строк применяется _метод сравнения среднеквадратичного отклонения (МССО)_.
_МССО_ - посимвольно производится следующая проверка:
    1. Вычисляется разность (t_diff) между средним временем и представленным для символьной пары;
    2. Разность (t_diff) сравнивается с данными о среднеквадратичного отклонения (s_d) для символьной пары;
    3. В случае, если _t_diff <= s_d_, то будет выставлен уровень в 100%, иначе же происходит вычисление по формуле s_d / t_diff ** 2 

- При смене пароля запускается процесс переобучения;

- Данные должны храниться отдельно для каждого устройства, с которого осуществляется доступ к системе;

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AlSerP/behavioral_verification.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
