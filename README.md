# Calcus-Test-Automation
Test Automation for https://calcus.ru/kalkulyator-ipoteki

## Installing requirements
This project uses ```Ruby 2.7.6-1 with devkit``` and ```Selenium webdriver```

You will need to install:

Selenium webdriver: ```gem install selenium-webdriver```

Selenium webdriver development dependencies: ```gem install ffi```

## Running Autotest
You can run autotest using:

```ruby TestCalcus.rb```

## Test steps

1. go to "https://calcus.ru/kalkulyator-ipoteki"
2. check the elements
3. input 12000000 in 'Стоимость недвижимости'
4. select % in 'Первоначальный взнос'
5. input 20 in 'Первоначальный взнос'
6. check text «2 400 000 руб.» in «Первоначальный взнос»
7. check text «9 600 000 руб.» in «Сумма кредита»
8. input 20 in 'Срок кредита'
9. input @random_number in 'Процентная ставка'
10. check and select radiobutton «Аннуитетные» and unselect radiobutton «Дифференцированные»
11. click button «Рассчитать»
12. check «Ежемесячный платеж»
