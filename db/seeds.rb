exit if !Rails.env.development?

puts "Creating Seed Data"

if user = User.find_by_email("seed@example.com")
  puts "Deleting HealthStatuses for seed"
  user.health_statuses.delete_all
else
  puts "Creating User seed"
  user = User.create(email: "seed@example.com", password: "password", password_confirmation: "password", email_confirmed_at: Time.current)
end

puts "Creating HealthStatuses for seed"
30.downto(1) do |i|
  if rand(1..4) != 4 && i % 6 != 0
    HealthStatus.create(
      user: user,
      mindfulness: rand(0..10),
      physically_active: rand(0..10),
      happiness: rand(0..10),
      diet: rand(0..10),
      mentally_active: rand(0..10),
      socially_active: rand(0..10),
      created_at: i.days.ago
    )
  end
end


if user = User.find_by_email("longseed@example.com")
  puts "Deleting HealthStatuses for longseed"
  user.health_statuses.delete_all
else
  puts "Creating User longseed"
  user = User.create(email: "longseed@example.com", password: "password", password_confirmation: "password", email_confirmed_at: Time.current)
end

puts "Creating HealthStatuses for longseed"
420.downto(1) do |i|
  if rand(1..4) != 4 && i % 6 != 0
    HealthStatus.create(
      user: user,
      mindfulness: rand(0..10),
      physically_active: rand(0..10),
      happiness: rand(0..10),
      diet: rand(0..10),
      mentally_active: rand(0..10),
      socially_active: rand(0..10),
      created_at: i.days.ago
    )
  end
end
