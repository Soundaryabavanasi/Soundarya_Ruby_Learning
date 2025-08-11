# spec/support/console_report_with_screenshots.rb
require 'fileutils'
require 'logger'

RSpec.configure do |config|
  results = []
  logger = Logger.new('log/test_steps.log')
  logger.level = Logger::INFO
  FileUtils.mkdir_p('tmp/screenshots')

  def take_screenshot_for(example, logger)
    # prefer instance var @driver if available (Selenium::WebDriver)
    driver_obj = defined?(@driver) && @driver ? @driver : nil

    # Try Capybara if available
    if driver_obj.nil? && defined?(Capybara)
      begin
        driver_obj = Capybara.current_session.driver.browser
      rescue => e
        driver_obj = nil
      end
    end

    return nil unless driver_obj && driver_obj.respond_to?(:save_screenshot)

    timestamp = Time.now.strftime('%Y%m%d-%H%M%S')
    safe_name = example.full_description.gsub(/[^\w\s-]/, '').gsub(/\s+/, '_')[0..80]
    path = "tmp/screenshots/#{timestamp}_#{safe_name}.png"
    begin
      # Selenium's save_screenshot path support
      driver_obj.save_screenshot(path)
      logger.info("Saved screenshot for #{example.full_description} => #{path}")
      path
    rescue => e
      logger.warn("Failed to save screenshot: #{e.message}")
      nil
    end
  end

  config.around(:each) do |example|
    logger.info("START: #{example.full_description}")
    start = Time.now
    example.run
    duration = (Time.now - start).round(3)

    screenshot = nil
    if example.exception
      begin
        screenshot = take_screenshot_for(example, logger)
      rescue => e
        logger.warn("Screenshot hook error: #{e.message}")
      end
    end

    results << {
      description: example.full_description,
      file_path: example.metadata[:file_path],
      line_number: example.metadata[:line_number],
      status: example.exception ? 'FAILED' : 'PASSED',
      exception: example.exception && example.exception.message,
      duration: duration,
      screenshot: screenshot
    }

    logger.info("END: #{example.full_description} (#{duration}s) - #{results.last[:status]}")
  end

  config.after(:suite) do
    total = results.size
    passed = results.count { |r| r[:status] == 'PASSED' }
    failed = results.count { |r| r[:status] == 'FAILED' }
    time = results.sum { |r| r[:duration] }

    puts "\n=== TEST SUMMARY ==="
    puts "Total: #{total} | Passed: #{passed} | Failed: #{failed} | Time: #{time.round(3)}s"
    puts "--------------------"

    if failed > 0
      puts "Failed tests (quick view):"
      results.select{ |r| r[:status]=='FAILED' }.each_with_index do |r, i|
        puts "#{i+1}) #{r[:description]}"
        puts "   #{r[:file_path]}:#{r[:line_number]}"
        puts "   Error: #{r[:exception].to_s.lines.first}"
        puts "   Duration: #{r[:duration]}s"
        puts "   Screenshot: #{r[:screenshot] || 'none'}"
      end
    end

    # write a machine readable summary too
    File.write("tmp/test_summary_console.txt", [
      "Total: #{total} | Passed: #{passed} | Failed: #{failed} | Time: #{time.round(3)}s",
      *results.map { |r| "#{r[:status]} - #{r[:description]} (#{r[:duration]}s) Screenshot: #{r[:screenshot] || 'none'}" }
    ].join("\n"))

    puts "Summary written to tmp/test_summary_console.txt"
    puts "Screenshots (if any) are in tmp/screenshots/"
  end
end
