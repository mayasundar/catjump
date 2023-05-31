require 'ruby2d'

set width: 800, height: 600

cat = Image.new('cat.png', x: 10, y: 10, width: 75, height: 100,
)
platform = Image.new('platform.png', x: 10, y: 8,width: 75, height: 100)

platforms = []
platforms << platform  # Add the initial platform to the array

jumping = false  # Initialize the jumping variable
jump_power = 0  # Initialize the jump_power variable
gravity = 0  # Initialize the gravity variable

on :key_down do |event|
  case event.key
  when 'space'
    if !jumping
      jump_power = 15  # Adjust this value to control the jump height
      gravity = 1  # Adjust this value to control the gravity
      jumping = true
    end
  when 'left'
    cat.x -= 10
  when 'right'
    cat.x += 10
  end
end

def generate_platforms(platforms, platform, count)
  lowest_y = platforms.map(&:y).max || Window.height
  min_height = 5 * platform.height  # Minimum height between platforms

  count.times do
    new_y = lowest_y - rand(min_height..2 * min_height)
    new_platform = Image.new('platform.png', x: rand(0..(Window.width - platform.width)), y: new_y)
    platforms << new_platform
    lowest_y = new_y
  end
end

# Generate initial platforms
generate_platforms(platforms, platform, 10)

update do
  if jumping
    cat.y -= jump_power
    jump_power -= gravity

    # Stop the jump when the cat reaches the ground (or a platform)
    if cat.y >= 400
      cat.y = 400
      jumping = false
    end
  end

  # Move the platforms downward
  platforms.each { |p| p.y += 2 }

  # Check if the cat collides with a platform
  platforms.each do |platform|
    if cat.y + cat.height >= platform.y && cat.y <= platform.y + platform.height &&
       cat.x + cat.width >= platform.x && cat.x <= platform.x + platform.width
      cat.y = platform.y - cat.height
      jumping = false
    end
  end

  # Generate new platforms when needed
  if platforms.last.y >= Window.height - platform.height
    generate_platforms(platforms, platform, 5)
  end

  # Remove platforms that have moved off the screen
  platforms.reject! { |platform| platform.y > Window.height }

  clear
  platforms.each { |platform| platform.draw }
  cat.draw
end

show
