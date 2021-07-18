require "selenium-webdriver"

# Инициализация стартового индекса, с которого вести пробег по html страницам
page_index = 0
# Инициализация пустого массива для сбора индексов страниц, не имеющих ссылки на последующую
pages_without_link = []
# Булевая переменная для цикла, перевести в true при нахождении на странице индикатора последней страницы
last_page = false
# Сабстринг для поиска последней страницы
last_page_text = "последняя страница"
# Ссылка на страницу с тестовым заданием
page_link = "http://qa-web-test-task.s3-website.eu-central-1.amazonaws.com"

driver = Selenium::WebDriver.for :chrome

until last_page do
  next_page_link = "http://qa-web-test-task.s3-website.eu-central-1.amazonaws.com/#{page_index + 1}.html"

  driver.get(page_link)

  # Выход из цикла, если текст на странице содержит указание на то, что страница последняя
  if driver.page_source.include?(last_page_text)
    last_page = true
    break
  end

  # Поиск ссылки на странице и записью значения тега href в переменную для последующего сравнения
  begin
    link = driver.find_element(:css, 'a')
    href_in_link = link.attribute("href")
  rescue
  end

  # Запись в массив ссылок на невалидные страницы
  pages_without_link << page_link if href_in_link != next_page_link

  page_index += 1
  # Обновляется после перезаписи индекса, при первом проходе ссылка ведет на страницу тестового задания
  page_link = "http://qa-web-test-task.s3-website.eu-central-1.amazonaws.com/#{page_index}.html"
end

puts "Список страниц без ссылки на последующую страницу:"
puts pages_without_link
