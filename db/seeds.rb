Message.destroy_all

Message.create :date => Time.now, :user => "Jake", :message => "How are you today?", :color => "#00aa00"
Message.create :date => Time.now, :user => "Beaker", :message => "Good Mate", :color => "#0011aa"
Message.create :date => Time.now, :user => "Jake", :message => "OOoo nice", :color => "#00aa00"
Message.create :date => Time.now, :user => "Beaker", :message => "Yea yoou??", :color => "#0011aa"
Message.create :date => Time.now, :user => "Jake", :message => "Couldn't be better, couldn't be better", :color => "#00aa00"
Message.create :date => Time.now, :user => "Beaker", :message => "Nice", :color => "#0011aa"
Message.create :date => Time.now, :user => "Jake", :message => "I'm having a couple of friends over and ...they are chickOONEs", :color => "#00aa00"
Message.create :date => Time.now, :user => "Beaker", :message => "OOoh i think they alrdy came...!", :color => "#0011aa"
Message.create :date => Time.now, :user => "Rolphie", :message => "Yea they came for dinner", :color => "#aa0000"

puts "Database has been seeded."