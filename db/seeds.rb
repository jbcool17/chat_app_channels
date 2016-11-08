Message.destroy_all
User.destroy_all
Channel.destroy_all


user1 = User.create name: 'Jake', color: '#5bacff'
user2 = User.create name: 'Beaker', color: '#5bac44'
user3 = User.create name: 'Rolphie', color: '#ffac55'
status_user = User.create(name: 'STATUS', color: '#D3D3D3')

channel1 = Channel.create name: 'Ducks'
channel2 = Channel.create name: 'Dogs'
channel3 = Channel.create name: 'Fish'

Message.create :date => Time.now, :message => "#{user1.name} HAS JOINED THE CHANNEL.", user_id: status_user.id, channel_id: channel1.id
Message.create :date => Time.now, :message => "#{user2.name} HAS JOINED THE CHANNEL.", user_id: status_user.id, channel_id: channel1.id
Message.create :date => Time.now, :message => "#{user3.name} HAS JOINED THE CHANNEL.", user_id: status_user.id, channel_id: channel1.id


Message.create :date => Time.now, :message => "How are you today?", user_id: user1.id, channel_id: channel1.id
Message.create :date => Time.now, :message => "Good Mate", user_id: user2.id, channel_id: channel1.id
Message.create :date => Time.now, :message => "OOoo nice", user_id: user1.id, channel_id: channel1.id
Message.create :date => Time.now, :message => "Yea yoou??", user_id: user2.id, channel_id: channel1.id
Message.create :date => Time.now, :message => "Couldn't be better, couldn't be better", user_id: user1.id, channel_id: channel1.id
Message.create :date => Time.now, :message => "Nice", user_id: user2.id, channel_id: channel1.id
Message.create :date => Time.now, :message => "I'm having a couple of friends over and ...they are chickOONEs", user_id: user1.id, channel_id: channel1.id
Message.create :date => Time.now, :message => "OOoh i think they alrdy came...!", user_id: user2.id, channel_id: channel1.id
Message.create :date => Time.now, :message => "Yea they came for dinner", user_id: user3.id, channel_id: channel1.id

puts "========================="
puts "Database has been seeded."
puts "========================="
