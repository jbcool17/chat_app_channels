Message.destroy_all
User.destroy_all
Channel.destroy_all

Message.create :date => Time.now, :user => "Jake", :message => "How are you today?", :color => "#00aa00", :channel_name => "live"
Message.create :date => Time.now, :user => "Beaker", :message => "Good Mate", :color => "#0044aa", :channel_name => "live"
Message.create :date => Time.now, :user => "Jake", :message => "OOoo nice", :color => "#00aa00", :channel_name => "live"
Message.create :date => Time.now, :user => "Beaker", :message => "Yea yoou??", :color => "#0044aa", :channel_name => "live"
Message.create :date => Time.now, :user => "Jake", :message => "Couldn't be better, couldn't be better", :color => "#00aa00", :channel_name => "live"
Message.create :date => Time.now, :user => "Beaker", :message => "Nice", :color => "#0044aa", :channel_name => "live"
Message.create :date => Time.now, :user => "Jake", :message => "I'm having a couple of friends over and ...they are chickOONEs", :color => "#00aa00", :channel_name => "live"
Message.create :date => Time.now, :user => "Beaker", :message => "OOoh i think they alrdy came...!", :color => "#0044aa", :channel_name => "live"
Message.create :date => Time.now, :user => "Rolphie", :message => "Yea they came for dinner", :color => "#aa0000", :channel_name => "live"

Message.create :date => Time.now, :user => "Jake", :message => "How are you today?", :color => "#00aa00", :channel_name => "manual"
Message.create :date => Time.now, :user => "Beaker", :message => "Good Mate", :color => "#0044aa", :channel_name => "manual"
Message.create :date => Time.now, :user => "Jake", :message => "OOoo nice", :color => "#00aa00", :channel_name => "manual"
Message.create :date => Time.now, :user => "Beaker", :message => "Yea yoou??", :color => "#0044aa", :channel_name => "manual"
Message.create :date => Time.now, :user => "Jake", :message => "Couldn't be better, couldn't be better", :color => "#00aa00", :channel_name => "manual"
Message.create :date => Time.now, :user => "Beaker", :message => "Nice", :color => "#0044aa", :channel_name => "manual"
Message.create :date => Time.now, :user => "Jake", :message => "I'm having a couple of friends over and ...they are chickOONEs", :color => "#00aa00", :channel_name => "manual"
Message.create :date => Time.now, :user => "Beaker", :message => "OOoh i think they alrdy came...!", :color => "#0044aa", :channel_name => "manual"
Message.create :date => Time.now, :user => "Rolphie", :message => "Yea they came for dinner", :color => "#aa0000", :channel_name => "manual"

Message.create :date => Time.now, :user => "Jake", :message => "How are you today?", :color => "#00aa00", :channel_name => "websockets"
Message.create :date => Time.now, :user => "Beaker", :message => "Good Mate", :color => "#0044aa", :channel_name => "websockets"
Message.create :date => Time.now, :user => "Jake", :message => "OOoo nice", :color => "#00aa00", :channel_name => "websockets"
Message.create :date => Time.now, :user => "Beaker", :message => "Yea yoou??", :color => "#0044aa", :channel_name => "websockets"
Message.create :date => Time.now, :user => "Jake", :message => "Couldn't be better, couldn't be better", :color => "#00aa00", :channel_name => "websockets"
Message.create :date => Time.now, :user => "Beaker", :message => "Nice", :color => "#0044aa", :channel_name => "websockets"
Message.create :date => Time.now, :user => "Jake", :message => "I'm having a couple of friends over and ...they are chickOONEs", :color => "#00aa00", :channel_name => "websockets"
Message.create :date => Time.now, :user => "Beaker", :message => "OOoh i think they alrdy came...!", :color => "#0044aa", :channel_name => "websockets"
Message.create :date => Time.now, :user => "Rolphie", :message => "Yea they came for dinner", :color => "#aa0000", :channel_name => "websockets"

User.create name: 'user4', color: '#5bacff'
User.create name: 'user2', color: '#5bac44'
User.create name: 'user3', color: '#ffac55'

Channel.create name: 'websockets'
Channel.create name: 'live'
Channel.create name: 'manual'

puts "Database has been seeded."
