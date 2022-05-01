require 'rubygems'
require 'selenium-webdriver'
require 'test-unit'
require 'webdrivers'

class CalcusTest < Test::Unit::TestCase

	def setup
		@driver = Selenium::WebDriver.for :chrome
		@url = "https://calcus.ru/kalkulyator-ipoteki"
		@driver.manage.timeouts.implicit_wait = 10
	end

	def create_random_number
		@random_number = rand(5..12)
	end

	def calculate_monthly_payment
		@i_percent = (@random_number / 100.0 / 12.0)
		@calc_temp = ((1.0 + @i_percent)**240)
		@monthly_payment = 9600000.0 * ((@i_percent * @calc_temp) / (@calc_temp-1))
		@monthly_payment = @monthly_payment.round(2)
	end

	def test_calcus
		#1_go to "https://calcus.ru/kalkulyator-ipoteki"
		@driver.get(@url)

		#2_check the elements
		#search for 'Ипотечный калькулятор'
		@driver.find_element(:xpath => "//h1[text() = 'Ипотечный калькулятор']")

		#search for 'По стоимости недвижимости'
		@driver.find_element(:xpath => "//a[text() = 'По стоимости недвижимости']")

		#search for 'По сумме кредита'
		@driver.find_element(:xpath => "//a[text() = 'По сумме кредита']")

		#search for 'Стоимость недвижимости'
		@driver.find_element(:xpath => "//div[text() = 'Стоимость недвижимости']")

		#search for 'Первоначальный взнос'
		@driver.find_element(:xpath => "//div[text() = 'Первоначальный взнос']")

		#search for 'Сумма кредита'
		@driver.find_element(:xpath => "//div[text() = 'Сумма кредита']")

		#search for 'Срок кредита'
		@driver.find_element(:xpath => "//div[text() = 'Срок кредита']")

		#search for 'Процентная ставка'
		@driver.find_element(:xpath => "//div[contains(text(), 'Процентная ставка')]")

		#search for 'Тип ежемесячных платежей'
		@driver.find_element(:xpath => "//div[contains(text(), 'Тип ежемесячных платежей')]")

		#3_input 12000000 in 'Стоимость недвижимости'
		@driver.find_element(:name, 'cost').send_keys("12000000")

		#4_select % in 'Первоначальный взнос'
		options = @driver.find_elements(:xpath => "//select[@name='start_sum_type']/option")
		options.find{|x| x.text == "%" }.click

		#5_input 20 in 'Первоначальный взнос'
		@driver.find_element(:name, 'start_sum').send_keys("20")

		#6_check text «2 400 000 руб.» in «Первоначальный взнос»
		start_sum = @driver.find_element(:class, 'start_sum_equiv')
		assert(start_sum.text == '(2 400 000 руб.)', "(2 400 000 руб.) not found!")

		#7_check text «9 600 000 руб.» in «Сумма кредита»
		loan_amount = @driver.find_element(:class, 'text-muted')
		assert(loan_amount.text == '9 600 000', "9 600 000 not found!")
		calc_input_desc = @driver.find_element(:class, 'calc-input-desc')
		assert(calc_input_desc.text == 'руб.', "руб. not found!")

		#8_input 20 in 'Срок кредита'
		@driver.find_element(:name, 'period').send_keys("20")

		#9_input @random_number in 'Процентная ставка'
		create_random_number
		@driver.find_element(:name, 'percent').send_keys(@random_number)

		#10_check and select radiobutton «Аннуитетные» and unselect radiobutton «Дифференцированные»
		payment_type_radio1 = @driver.find_element(:id, 'payment-type-1')
		@driver.find_element(:xpath => "//label[@for='payment-type-1']").click
		assert(payment_type_radio1.selected?, "«Аннуитетные» unselected!")

		payment_type_radio2 = @driver.find_element(:id, 'payment-type-2')
		assert(payment_type_radio2.selected? == false, "«Дифференцированные» selected!")

		#11_click button «Рассчитать»
		@driver.find_element(:class, 'calc-submit').click
		sleep 3

		#12_check «Ежемесячный платеж»
		calculate_monthly_payment
		monthly_payment_result = @driver.find_element(:class, 'result-placeholder-monthlyPayment')

		monthly_payment_string = @monthly_payment.to_s
		if monthly_payment_string[-2] == "."
			monthly_payment_string.insert(-1, "0")
		end
		monthly_payment_string = monthly_payment_string.sub(".", ",")
		monthly_payment_string.insert(-7, " ")
		assert(monthly_payment_result.text == monthly_payment_string, "«Ежемесячный платеж» is not correct!")

		wait = Selenium::WebDriver::Wait.new(:timeout => 5)
	end

	def teardown
	  @driver.quit
	end

end