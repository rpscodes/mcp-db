-- SkyVision Drones - Customer Support Chat Database Schema

-- Products table
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Customers table
CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Chat sessions table
CREATE TABLE chat_sessions (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    product_id INTEGER REFERENCES products(id),
    status VARCHAR(50) NOT NULL, -- open, resolved, escalated
    category VARCHAR(100) NOT NULL, -- support, troubleshooting, complaint, feedback
    priority VARCHAR(20) DEFAULT 'medium', -- low, medium, high
    satisfaction_rating INTEGER CHECK (satisfaction_rating BETWEEN 1 AND 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP
);

-- Messages table
CREATE TABLE messages (
    id SERIAL PRIMARY KEY,
    session_id INTEGER REFERENCES chat_sessions(id),
    sender VARCHAR(50) NOT NULL, -- customer, agent
    content TEXT NOT NULL,
    sentiment VARCHAR(20), -- positive, neutral, negative
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert drone products
INSERT INTO products (name, category) VALUES
('SkyVision Pro', 'Consumer Drones'),
('Scout Mini', 'Consumer Drones'),
('AeroMax 4K', 'Consumer Drones'),
('AgriScan 200', 'Commercial Drones'),
('SurveyHawk X1', 'Commercial Drones'),
('PropGuard Set', 'Accessories'),
('FlightPack Battery 6000mAh', 'Batteries & Power'),
('DroneLink Controller', 'Controllers'),
('VisionCam Gimbal', 'Cameras & Gimbals'),
('QuickCharge Hub', 'Batteries & Power');

-- Insert customers
INSERT INTO customers (name, email) VALUES
('Alex Rivera', 'alex.rivera@email.com'),
('Priya Sharma', 'priya.sharma@email.com'),
('Marcus Johnson', 'marcus.j@email.com'),
('Elena Kowalski', 'elena.k@email.com'),
('Tyler Brooks', 'tyler.brooks@email.com'),
('Mei Lin Chen', 'mchen@email.com'),
('Ryan O''Connor', 'ryan.oc@email.com'),
('Sofia Ramirez', 'sofia.r@email.com'),
('Nathan Park', 'npark@email.com'),
('Hannah Nguyen', 'hnguyen@email.com'),
('Carlos Mendez', 'cmendez@email.com'),
('Aisha Patel', 'apatel@email.com'),
('Jake Morrison', 'jmorrison@email.com'),
('Olivia Chang', 'ochang@email.com'),
('Derek Foster', 'dfoster@email.com');

-- Insert chat sessions with drone support scenarios
INSERT INTO chat_sessions (customer_id, product_id, status, category, priority, satisfaction_rating, created_at, resolved_at) VALUES
-- Session 1: SkyVision Pro motor failure
(1, 1, 'resolved', 'troubleshooting', 'high', 4, '2024-01-15 10:30:00', '2024-01-15 11:15:00'),
-- Session 2: Scout Mini compass calibration
(2, 2, 'resolved', 'support', 'medium', 5, '2024-01-16 14:20:00', '2024-01-16 15:00:00'),
-- Session 3: AeroMax 4K camera quality complaint
(3, 3, 'resolved', 'complaint', 'high', 2, '2024-01-17 09:00:00', '2024-01-17 10:30:00'),
-- Session 4: SkyVision Pro positive feedback
(4, 1, 'resolved', 'feedback', 'low', 5, '2024-01-18 16:30:00', '2024-01-18 16:50:00'),
-- Session 5: FlightPack Battery swollen/safety issue
(5, 7, 'resolved', 'complaint', 'high', 3, '2024-01-19 11:00:00', '2024-01-19 12:30:00'),
-- Session 6: DroneLink Controller connectivity
(6, 8, 'resolved', 'troubleshooting', 'medium', 4, '2024-01-20 13:15:00', '2024-01-20 14:00:00'),
-- Session 7: AgriScan 200 firmware update failure
(7, 4, 'resolved', 'troubleshooting', 'high', 2, '2024-01-21 10:00:00', '2024-01-21 11:30:00'),
-- Session 8: Scout Mini GPS calibration error
(8, 2, 'resolved', 'troubleshooting', 'medium', 4, '2024-01-22 15:00:00', '2024-01-22 15:45:00'),
-- Session 9: QuickCharge Hub setup support
(9, 10, 'resolved', 'support', 'low', 5, '2024-01-23 09:30:00', '2024-01-23 10:00:00'),
-- Session 10: AeroMax 4K great flight stability feedback
(10, 3, 'resolved', 'feedback', 'low', 5, '2024-01-24 14:00:00', '2024-01-24 14:20:00'),
-- Session 11: SurveyHawk X1 RTH not working
(11, 5, 'resolved', 'troubleshooting', 'high', 2, '2024-01-25 10:30:00', '2024-01-25 12:00:00'),
-- Session 12: VisionCam Gimbal malfunction
(12, 9, 'resolved', 'complaint', 'medium', 3, '2024-01-26 11:00:00', '2024-01-26 12:15:00'),
-- Session 13: SkyVision Pro warranty claim - cracked shell
(13, 1, 'resolved', 'support', 'high', 4, '2024-01-27 16:00:00', '2024-01-27 17:00:00'),
-- Session 14: PropGuard Set compatibility question
(14, 6, 'resolved', 'support', 'low', 5, '2024-01-28 09:00:00', '2024-01-28 09:30:00'),
-- Session 15: Scout Mini feature request - follow-me mode
(15, 2, 'resolved', 'feedback', 'low', 4, '2024-01-29 13:00:00', '2024-01-29 13:30:00'),
-- Session 16: FlightPack Battery fast drain
(1, 7, 'resolved', 'complaint', 'high', 2, '2024-01-30 10:00:00', '2024-01-30 11:30:00'),
-- Session 17: AgriScan 200 setup and first flight
(2, 4, 'resolved', 'support', 'medium', 5, '2024-01-31 14:00:00', '2024-01-31 14:45:00'),
-- Session 18: SkyVision Pro lost drone - signal loss
(3, 1, 'resolved', 'complaint', 'high', 1, '2024-02-01 09:30:00', '2024-02-01 11:00:00'),
-- Session 19: DroneLink Controller won't pair (open)
(4, 8, 'open', 'troubleshooting', 'medium', NULL, '2024-02-02 15:00:00', NULL),
-- Session 20: SurveyHawk X1 unstable hover (open)
(5, 5, 'open', 'troubleshooting', 'high', NULL, '2024-02-02 16:00:00', NULL),
-- Session 21: AeroMax 4K propeller damage warranty
(6, 3, 'resolved', 'support', 'medium', 3, '2024-02-03 10:00:00', '2024-02-03 11:00:00'),
-- Session 22: SkyVision Pro obstacle avoidance feature request
(7, 1, 'resolved', 'feedback', 'low', 5, '2024-02-04 14:00:00', '2024-02-04 14:30:00'),
-- Session 23: FlightPack Battery won't charge
(8, 7, 'resolved', 'troubleshooting', 'high', 3, '2024-02-05 09:00:00', '2024-02-05 10:00:00'),
-- Session 24: Scout Mini drone won't arm
(9, 2, 'resolved', 'troubleshooting', 'high', 4, '2024-02-06 11:00:00', '2024-02-06 12:00:00'),
-- Session 25: AgriScan 200 waypoint mission request
(10, 4, 'resolved', 'feedback', 'low', 5, '2024-02-07 13:00:00', '2024-02-07 13:30:00');

-- Session 1: SkyVision Pro motor failure
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(1, 'customer', 'Hi, my SkyVision Pro''s rear-left motor is making a grinding noise and the drone is pulling to one side during flight. I''ve only had it for 3 months.', 'negative', '2024-01-15 10:30:00'),
(1, 'agent', 'Hello Alex! I''m sorry to hear about the motor issue. That grinding noise definitely isn''t normal. Can you tell me — did you notice this after a hard landing or crash, or did it start gradually?', 'neutral', '2024-01-15 10:32:00'),
(1, 'customer', 'No crashes. It started about a week ago as a slight vibration, and now it''s a clear grinding sound. The drone drifts left even in GPS mode.', 'negative', '2024-01-15 10:35:00'),
(1, 'agent', 'That sounds like a bearing failure in the motor. First, let''s confirm: power off the drone and try spinning each motor by hand. Does the affected motor feel rough or gritty compared to the others?', 'neutral', '2024-01-15 10:37:00'),
(1, 'customer', 'Yes! The rear-left motor feels gritty when I spin it. The other three spin smoothly.', 'neutral', '2024-01-15 10:42:00'),
(1, 'agent', 'That confirms a motor bearing failure. Since your drone is within the 12-month warranty period, we''ll send you a replacement motor at no charge. You can swap it yourself — it''s just 4 screws — or we can arrange a service center repair. Which do you prefer?', 'neutral', '2024-01-15 10:45:00'),
(1, 'customer', 'I can do it myself if you send a tutorial link. How long for shipping?', 'neutral', '2024-01-15 10:50:00'),
(1, 'agent', 'I''ll email you the motor replacement video guide right away. The replacement motor ships within 24 hours and should arrive in 2-3 business days. After installing, run a motor calibration from the SkyVision app before flying.', 'positive', '2024-01-15 10:52:00'),
(1, 'customer', 'Great, thanks for the quick help! I''ll watch for the email.', 'positive', '2024-01-15 10:55:00'),
(1, 'agent', 'You''re welcome, Alex! After installing the new motor, if you notice any vibration during hover test, let us know immediately. Happy flying!', 'positive', '2024-01-15 11:15:00');

-- Session 2: Scout Mini compass calibration
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(2, 'customer', 'I just got my Scout Mini and it keeps showing a "Compass Error" warning. I can''t take off. Help!', 'negative', '2024-01-16 14:20:00'),
(2, 'agent', 'Hi Priya! Welcome to the SkyVision family! The compass error on first flight is very common — the drone needs to be calibrated to your local magnetic environment. Have you done the compass calibration yet?', 'positive', '2024-01-16 14:22:00'),
(2, 'customer', 'No, I don''t know how to do that. The quick start guide didn''t mention it.', 'neutral', '2024-01-16 14:25:00'),
(2, 'agent', 'No worries! Here''s how: 1) Open the SkyVision app and tap Drone Settings > Sensors > Compass Calibration. 2) Hold the drone level and rotate 360 degrees slowly. 3) Then tilt it nose-down and rotate another 360 degrees. The app will confirm when done. Make sure you''re away from metal structures and cars.', 'neutral', '2024-01-16 14:28:00'),
(2, 'customer', 'I''m in a parking garage. Could that be the problem?', 'neutral', '2024-01-16 14:32:00'),
(2, 'agent', 'Absolutely! Parking garages have tons of metal rebar and structures that interfere with the compass. Move to an open field or park away from metal objects and power lines, then try the calibration again.', 'neutral', '2024-01-16 14:35:00'),
(2, 'customer', 'That worked perfectly! I went to the park and calibrated it. It''s flying great now. Thank you so much!', 'positive', '2024-01-16 14:50:00'),
(2, 'agent', 'Wonderful! Pro tip: you may need to recalibrate when you travel to a new location far from home, as the magnetic field changes. Enjoy your Scout Mini! Feel free to reach out anytime.', 'positive', '2024-01-16 15:00:00');

-- Session 3: AeroMax 4K camera quality complaint
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(3, 'customer', 'I bought the AeroMax 4K specifically for its camera and I''m very disappointed. The video quality is nothing like what was advertised. Everything looks washed out and blurry at 4K.', 'negative', '2024-01-17 09:00:00'),
(3, 'agent', 'I''m sorry to hear that, Marcus. Let''s look into this. Can you confirm what recording settings you''re using? Go to Camera Settings and tell me the resolution, frame rate, and color profile.', 'neutral', '2024-01-17 09:03:00'),
(3, 'customer', 'It says 4K at 30fps, color profile is set to "Normal".', 'neutral', '2024-01-17 09:07:00'),
(3, 'agent', 'Try switching the color profile to "D-Log" — this is a flat profile that captures more dynamic range and is meant for color grading in post. Also, set the white balance manually instead of auto. What lighting conditions are you filming in?', 'neutral', '2024-01-17 09:10:00'),
(3, 'customer', 'Mostly outdoor daytime shots. But honestly, I shouldn''t need to do post-production on a $900 drone. The sample footage on your website looks amazing straight out of camera.', 'negative', '2024-01-17 09:15:00'),
(3, 'agent', 'You make a fair point. The "Vivid" color profile should give you much better out-of-camera results. Also, make sure your lens is clean and the protective film has been removed — there''s a small film on the lens that''s easy to miss.', 'neutral', '2024-01-17 09:20:00'),
(3, 'customer', 'Oh wait... there was a lens film! I just peeled it off. Let me try some test shots.', 'neutral', '2024-01-17 09:40:00'),
(3, 'customer', 'Okay the lens film fixed the blurriness but the colors are still flat compared to your marketing videos. I''m going to return this.', 'negative', '2024-01-17 10:00:00'),
(3, 'agent', 'I understand your frustration. I''ve initiated a return for you. You''ll receive a prepaid shipping label via email. The refund will process within 5-7 business days of receiving the unit. I''ll also pass your feedback about the color quality to our product team.', 'neutral', '2024-01-17 10:15:00'),
(3, 'customer', 'Fine. Thanks for trying to help at least.', 'negative', '2024-01-17 10:30:00');

-- Session 4: SkyVision Pro positive feedback
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(4, 'customer', 'I just wanted to say the SkyVision Pro is the best drone I''ve ever owned. The flight stability is incredible even in 20mph wind!', 'positive', '2024-01-18 16:30:00'),
(4, 'agent', 'Thank you so much for the kind words, Elena! We''re thrilled you''re enjoying your SkyVision Pro. The advanced IMU and triple-redundant GPS really shine in windy conditions. What do you mainly use it for?', 'positive', '2024-01-18 16:35:00'),
(4, 'customer', 'Real estate photography mostly. The 45-minute flight time is a game changer — I can cover multiple properties on a single battery. And the obstacle avoidance has saved me from trees more than once!', 'positive', '2024-01-18 16:40:00'),
(4, 'agent', 'Real estate is one of our favorite use cases! Have you tried the Hyperlapse and Waypoint Mission modes? They''re perfect for creating cinematic property tours. Also, we''re releasing a firmware update next month with improved ActiveTrack.', 'positive', '2024-01-18 16:43:00'),
(4, 'customer', 'I haven''t tried waypoints yet — I''ll look into that! Looking forward to the update.', 'positive', '2024-01-18 16:45:00'),
(4, 'agent', 'You''ll love it for real estate! Use code SKYLOYAL15 for 15% off your next accessory purchase. Thanks for being a valued SkyVision customer!', 'positive', '2024-01-18 16:48:00'),
(4, 'customer', 'Awesome, thanks! I might grab an extra battery.', 'positive', '2024-01-18 16:50:00');

-- Session 5: FlightPack Battery swollen
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(5, 'customer', 'I noticed my FlightPack Battery 6000mAh is bulging on one side. It doesn''t sit flat anymore. Is this dangerous?', 'negative', '2024-01-19 11:00:00'),
(5, 'agent', 'Tyler, thank you for contacting us — this is important. A swollen LiPo battery is a safety concern. Please stop using it immediately and do NOT charge it. Can you tell me how old the battery is and how you''ve been storing it?', 'neutral', '2024-01-19 11:03:00'),
(5, 'customer', 'I''ve had it about 6 months. I usually just leave it in the drone after flying. Sometimes it sits for a couple weeks between flights.', 'neutral', '2024-01-19 11:07:00'),
(5, 'agent', 'Leaving a LiPo fully charged or fully depleted for extended periods can cause swelling. For long-term storage, batteries should be at around 50% charge. That said, a battery swelling at 6 months is concerning — this is covered under warranty.', 'neutral', '2024-01-19 11:10:00'),
(5, 'customer', 'Great. How do I dispose of the swollen one? And how do I get a replacement?', 'neutral', '2024-01-19 11:15:00'),
(5, 'agent', 'DO NOT throw it in regular trash. Take it to a battery recycling center or electronics store that accepts LiPo batteries. We''ll ship a free replacement under warranty. I''m processing that now. You''ll receive it in 3-5 business days.', 'neutral', '2024-01-19 11:18:00'),
(5, 'customer', 'Alright. It''s frustrating that the battery didn''t last even 6 months though. I expect better from a $90 battery.', 'negative', '2024-01-19 11:30:00'),
(5, 'agent', 'I completely understand. I''ll flag this with our battery team. With the replacement, I recommend using the storage mode feature in the SkyVision app — it automatically discharges the battery to storage level after your flight. That will extend battery life significantly.', 'neutral', '2024-01-19 11:35:00'),
(5, 'customer', 'Okay, I''ll try that. Thanks for the help.', 'neutral', '2024-01-19 12:30:00');

-- Session 6: DroneLink Controller connectivity
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(6, 'customer', 'My DroneLink Controller keeps losing connection to my SkyVision Pro at only 500 meters. The spec says 5km range!', 'negative', '2024-01-20 13:15:00'),
(6, 'agent', 'Hi Mei Lin! That''s well below the expected range. Let me help troubleshoot. A few questions: Are you flying in an urban area? And are the controller''s antennas fully extended and pointed toward the drone?', 'neutral', '2024-01-20 13:18:00'),
(6, 'customer', 'I''m in a suburban neighborhood. The antennas are up. I also notice a lot of interference warnings in the app.', 'neutral', '2024-01-20 13:22:00'),
(6, 'agent', 'Suburban areas often have heavy WiFi interference on 2.4GHz. Try switching the controller to 5.8GHz mode: go to Controller Settings > Transmission > Frequency Band and select 5.8GHz. It has shorter max range but much less interference in populated areas.', 'neutral', '2024-01-20 13:25:00'),
(6, 'customer', 'Switched to 5.8GHz and the interference warnings went away. I''ll test range this weekend. Thanks!', 'positive', '2024-01-20 13:40:00'),
(6, 'agent', 'Great! On 5.8GHz in suburban areas you should get 2-3km reliably. Also make sure your firmware is up to date — our latest update improved signal stability. Happy flying!', 'positive', '2024-01-20 14:00:00');

-- Session 7: AgriScan 200 firmware update failure
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(7, 'customer', 'I tried updating my AgriScan 200 firmware and it failed at 60%. Now the drone won''t turn on at all. This is a $3,500 drone!', 'negative', '2024-01-21 10:00:00'),
(7, 'agent', 'I''m very sorry about this, Ryan. A failed firmware update can sometimes put the drone in a bricked state. Let''s try a recovery. Do you see any LED lights at all when you power on?', 'neutral', '2024-01-21 10:05:00'),
(7, 'customer', 'The LEDs blink red three times and then nothing. I can''t connect via the app either.', 'negative', '2024-01-21 10:10:00'),
(7, 'agent', 'Three red blinks indicates the flight controller is in recovery mode. Here''s what to do: 1) Download the AgriScan Firmware Recovery Tool from our website. 2) Connect the drone to your computer via USB-C. 3) Run the recovery tool and select "Force Flash Firmware."', 'neutral', '2024-01-21 10:15:00'),
(7, 'customer', 'I don''t have a USB-C cable that fits. The port on the drone looks different from standard USB-C.', 'negative', '2024-01-21 10:22:00'),
(7, 'agent', 'The AgriScan uses a locking USB-C connector to prevent disconnection during field updates. A standard USB-C cable should still fit — just push firmly until it clicks. If you''re still unable to connect, we need to bring this in for service.', 'neutral', '2024-01-21 10:30:00'),
(7, 'customer', 'I tried a standard cable and it doesn''t click in. I need this drone for crop surveying next week. This is really bad timing.', 'negative', '2024-01-21 10:40:00'),
(7, 'agent', 'I understand the urgency. I''m escalating this to priority service. We''ll arrange next-day pickup and aim for 48-hour turnaround repair at no charge since this was a firmware issue on our end. I''ll email you the shipping details within the hour.', 'neutral', '2024-01-21 10:50:00'),
(7, 'customer', 'Alright, that''s the best option I guess. Please make it fast.', 'negative', '2024-01-21 11:00:00'),
(7, 'agent', 'Absolutely. I''ve marked this as urgent priority. You''ll also receive a loaner unit if the repair takes longer than 48 hours. I''m truly sorry for the inconvenience.', 'neutral', '2024-01-21 11:30:00');

-- Session 8: Scout Mini GPS calibration error
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(8, 'customer', 'My Scout Mini keeps drifting even in GPS mode. It won''t hold position and slowly moves east. I''ve tried calibrating the compass twice.', 'negative', '2024-01-22 15:00:00'),
(8, 'agent', 'Hi Sofia! GPS drift can have a few causes. First, how many GPS satellites does the app show when you''re flying? You need at least 10 for stable positioning.', 'neutral', '2024-01-22 15:03:00'),
(8, 'customer', 'It shows 7-8 satellites usually.', 'neutral', '2024-01-22 15:08:00'),
(8, 'agent', 'That''s marginal. Try waiting 2-3 minutes after power-on before taking off — this gives the GPS time to acquire more satellites. Also, check for a firmware update — version 2.4.1 improved GPS accuracy significantly.', 'neutral', '2024-01-22 15:12:00'),
(8, 'customer', 'I''m on version 2.3.0. Let me update and try again.', 'neutral', '2024-01-22 15:20:00'),
(8, 'customer', 'Updated and waited longer before takeoff. Now showing 12 satellites and the hover is rock solid! Thanks!', 'positive', '2024-01-22 15:35:00'),
(8, 'agent', 'Excellent! The firmware update added GLONASS satellite support in addition to GPS, which is why you''re seeing more satellites now. Enjoy your flights!', 'positive', '2024-01-22 15:45:00');

-- Session 9: QuickCharge Hub setup
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(9, 'customer', 'Just got the QuickCharge Hub. How many batteries can I charge at once and does it work with all SkyVision batteries?', 'neutral', '2024-01-23 09:30:00'),
(9, 'agent', 'Hi Nathan! Great choice! The QuickCharge Hub charges up to 4 FlightPack batteries simultaneously. It''s compatible with all SkyVision battery models including the 4000mAh, 6000mAh, and the new 8000mAh Pro batteries.', 'positive', '2024-01-23 09:33:00'),
(9, 'customer', 'Perfect! How long does it take to fully charge four 6000mAh batteries?', 'neutral', '2024-01-23 09:38:00'),
(9, 'agent', 'Charging 4 batteries sequentially takes about 3 hours total (45 minutes each). The hub charges them in order of charge level — the most charged battery goes first so it''s ready sooner. You can also set it to storage charge mode for long-term storage.', 'positive', '2024-01-23 09:42:00'),
(9, 'customer', 'That''s really smart. Love the design too. Thanks for the info!', 'positive', '2024-01-23 09:50:00'),
(9, 'agent', 'You''re welcome! One tip: the hub has a built-in display that shows battery health over time. Keep an eye on it to know when batteries need replacing. Happy flying!', 'positive', '2024-01-23 10:00:00');

-- Session 10: AeroMax 4K flight stability feedback
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(10, 'customer', 'Just wanted to drop some positive feedback — the AeroMax 4K is incredibly stable in flight. I''m getting buttery smooth footage even without an ND filter. Impressive for the price point!', 'positive', '2024-01-24 14:00:00'),
(10, 'agent', 'Thank you so much, Hannah! That''s great to hear. The AeroMax 4K has our latest 3-axis stabilization system. Have you tried the cinematic mode for even smoother movements?', 'positive', '2024-01-24 14:05:00'),
(10, 'customer', 'Yes! Cinematic mode is amazing for slow reveals. I''m a YouTuber and this drone is perfect for my travel videos. The compact folding design makes it easy to pack too.', 'positive', '2024-01-24 14:10:00'),
(10, 'agent', 'We love hearing from content creators! If you''d like, we can feature your channel on our Creator Spotlight page. Just send us some of your footage. Thanks for the wonderful feedback!', 'positive', '2024-01-24 14:15:00'),
(10, 'customer', 'That would be awesome! I''ll send some clips. Thanks!', 'positive', '2024-01-24 14:20:00');

-- Session 11: SurveyHawk X1 RTH not working
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(11, 'customer', 'Serious issue: my SurveyHawk X1''s Return-to-Home failed during a survey mission. The drone just kept flying away and I had to manually take over. This is unacceptable for a commercial drone!', 'negative', '2024-01-25 10:30:00'),
(11, 'agent', 'Carlos, I completely understand your concern — RTH reliability is critical, especially on commercial missions. Let me look into this. Was the RTH triggered automatically (low battery) or manually?', 'neutral', '2024-01-25 10:33:00'),
(11, 'customer', 'Low battery RTH. Battery hit 25% and it started RTH but then just flew in the wrong direction. I panicked and switched to manual.', 'negative', '2024-01-25 10:38:00'),
(11, 'agent', 'That''s very concerning. This can happen if the home point wasn''t properly set or if there was compass interference at the takeoff location. Can you check the flight log in the app? Go to Flight Records > select the flight > View Log. What does the home point status show at takeoff?', 'neutral', '2024-01-25 10:42:00'),
(11, 'customer', 'It says "Home Point Updated: GPS Accuracy 4.2m." That seems fine.', 'neutral', '2024-01-25 10:50:00'),
(11, 'agent', 'The GPS accuracy was fine, but I suspect compass interference at the survey site. Were you near any large metal structures, power lines, or mining equipment? I''d like to pull your flight log for engineering analysis. Can you export it and email it to support@skyvisiondrones.com?', 'neutral', '2024-01-25 11:00:00'),
(11, 'customer', 'We were surveying near some construction equipment. I''ll send the log, but I need assurance this won''t happen again. We can''t lose a $5,000 drone on a job site.', 'negative', '2024-01-25 11:15:00'),
(11, 'agent', 'Completely understood. I recommend: 1) Always do compass calibration at each new survey site, 2) Set a failsafe altitude higher than surrounding obstacles, 3) Update to firmware 3.2.0 which has improved RTH path planning around magnetic interference. I''m also adding a free compass module upgrade to your account. We take commercial reliability very seriously.', 'neutral', '2024-01-25 11:30:00'),
(11, 'customer', 'Okay, I''ll update the firmware and try the calibration steps. Send me the compass module.', 'neutral', '2024-01-25 12:00:00');

-- Session 12: VisionCam Gimbal malfunction
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(12, 'customer', 'My VisionCam Gimbal is tilting to the left and making a clicking noise. The video comes out tilted about 10 degrees.', 'negative', '2024-01-26 11:00:00'),
(12, 'agent', 'Hi Aisha! That sounds like a gimbal motor issue. Has the drone had any recent crashes or hard landings?', 'neutral', '2024-01-26 11:05:00'),
(12, 'customer', 'It had a minor tip-over during landing last week, but it didn''t seem like a big deal.', 'neutral', '2024-01-26 11:10:00'),
(12, 'agent', 'Even minor tip-overs can misalign the gimbal. Try this: power on the drone on a flat surface and go to Camera Settings > Gimbal > Auto Calibrate. This can often fix alignment issues from minor impacts.', 'neutral', '2024-01-26 11:15:00'),
(12, 'customer', 'I ran the auto calibration and the tilt is fixed, but the clicking noise is still there when panning left.', 'neutral', '2024-01-26 11:30:00'),
(12, 'agent', 'The clicking suggests a damaged gimbal roll motor. Since this resulted from a landing incident, it wouldn''t be covered under standard warranty. However, we offer gimbal repair service for $85. Would you like me to set that up?', 'neutral', '2024-01-26 11:45:00'),
(12, 'customer', 'That feels steep for what was barely a tip-over. But I need it working. Go ahead and set up the repair.', 'negative', '2024-01-26 12:00:00'),
(12, 'agent', 'I''ve set up the repair order. You''ll receive a prepaid shipping box within 2 days. Turnaround time is 5-7 business days. I''ve also applied a 15% discount bringing it to $72.25. For future landings, I recommend using the landing pad accessory for stability.', 'neutral', '2024-01-26 12:15:00');

-- Session 13: SkyVision Pro warranty claim - cracked shell
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(13, 'customer', 'My SkyVision Pro''s top shell has a hairline crack along the seam. I haven''t crashed it — it seems like a manufacturing defect. The crack appeared after normal use.', 'negative', '2024-01-27 16:00:00'),
(13, 'agent', 'Hi Jake! I''m sorry about that. We have seen a small batch of SkyVision Pros with a shell bonding issue. Can you send me a photo of the crack and your drone''s serial number? You can find it under the battery compartment.', 'neutral', '2024-01-27 16:05:00'),
(13, 'customer', 'Serial number is SVP-2024-08-14523. I''ll email the photo to support.', 'neutral', '2024-01-27 16:12:00'),
(13, 'agent', 'Thank you! I''ve confirmed your serial number falls within the affected batch. This is fully covered under our manufacturing defect warranty. We''ll send you a complete replacement shell assembly. Would you like to install it yourself or have us do it?', 'neutral', '2024-01-27 16:25:00'),
(13, 'customer', 'I''ll install it myself. Is it easy?', 'neutral', '2024-01-27 16:30:00'),
(13, 'agent', 'Yes, it''s straightforward — 8 screws and 2 ribbon cables. We''ll include illustrated instructions and the necessary screwdriver. The shell kit should arrive within 3-5 business days. Sorry again for the defect!', 'positive', '2024-01-27 16:40:00'),
(13, 'customer', 'No problem, these things happen. Appreciate the quick response and free replacement!', 'positive', '2024-01-27 17:00:00');

-- Session 14: PropGuard Set compatibility
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(14, 'customer', 'Quick question — does the PropGuard Set work with the Scout Mini? I want to fly indoors.', 'neutral', '2024-01-28 09:00:00'),
(14, 'agent', 'Hi Olivia! Yes, the PropGuard Set is compatible with the Scout Mini. It also fits the AeroMax 4K. Great choice for indoor flying — it protects both the props and your walls!', 'positive', '2024-01-28 09:05:00'),
(14, 'customer', 'Does it affect flight time or performance at all?', 'neutral', '2024-01-28 09:10:00'),
(14, 'agent', 'There''s a slight impact — roughly 3-4 minutes less flight time due to the added weight (45g). You may also notice slightly reduced top speed. But for indoor flying, it''s a worthwhile tradeoff for the safety margin. The guards also help with more stable indoor hover.', 'neutral', '2024-01-28 09:15:00'),
(14, 'customer', 'Sounds good, I''ll order a set. Thanks!', 'positive', '2024-01-28 09:20:00'),
(14, 'agent', 'You''re welcome! Pro tip: in the app, switch to "Indoor Mode" when using prop guards indoors — it turns off GPS (which is unreliable inside) and uses optical flow sensors for positioning instead. Happy indoor flying!', 'positive', '2024-01-28 09:30:00');

-- Session 15: Scout Mini feature request - follow-me mode
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(15, 'customer', 'Love my Scout Mini but I really wish it had a follow-me mode. I use it for mountain biking and manually controlling while riding is impossible. Any plans to add this?', 'neutral', '2024-01-29 13:00:00'),
(15, 'agent', 'Hi Derek! Thanks for the feedback. Follow-me mode is one of our most requested features for the Scout Mini. Currently, it''s available on the SkyVision Pro and AeroMax 4K. For the Scout Mini, it''s on our development roadmap for the next major firmware update.', 'neutral', '2024-01-29 13:05:00'),
(15, 'customer', 'Any ETA on that update? Also, can you add ActiveTrack too? That would be amazing for action sports.', 'neutral', '2024-01-29 13:10:00'),
(15, 'agent', 'We''re targeting Q2 2024 for the follow-me update on Scout Mini. ActiveTrack requires more processing power, so that may be limited to our higher-end models. I''ll definitely log your request for both features. In the meantime, the AeroMax 4K has both features if you need them sooner!', 'neutral', '2024-01-29 13:18:00'),
(15, 'customer', 'Q2 isn''t too far off. I''ll wait for the update. Thanks for passing along the feedback!', 'positive', '2024-01-29 13:25:00'),
(15, 'agent', 'Absolutely! Your feedback directly shapes our roadmap. We''ll send a notification when the update drops. Keep shredding those trails!', 'positive', '2024-01-29 13:30:00');

-- Session 16: FlightPack Battery fast drain
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(16, 'customer', 'My FlightPack Battery 6000mAh used to give me 40 minutes of flight. Now I''m getting barely 20 minutes. I''ve only had it 4 months and about 50 charge cycles.', 'negative', '2024-01-30 10:00:00'),
(16, 'agent', 'Hi Alex! A 50% drop in flight time after only 50 cycles is abnormal — these batteries are rated for 300+ cycles. Let me help diagnose. Can you check the battery health in the SkyVision app under Battery > Health Monitor?', 'neutral', '2024-01-30 10:05:00'),
(16, 'customer', 'It shows battery health at 68%. Cell voltages are 3.7V, 3.7V, 3.6V, 3.5V. That last cell seems low.', 'neutral', '2024-01-30 10:12:00'),
(16, 'agent', 'That confirms a weak cell. The 0.2V imbalance in cell 4 is causing the battery management system to cut off early to protect against over-discharge. This is a defective cell — not normal wear.', 'neutral', '2024-01-30 10:18:00'),
(16, 'customer', 'So it''s defective? I paid $90 for this battery and it lasted 4 months. Not happy.', 'negative', '2024-01-30 10:25:00'),
(16, 'agent', 'Completely understandable. This is covered under warranty. I''m sending a replacement battery immediately at no charge. Please stop using the current battery as an unbalanced cell can be a safety risk. Take it to a battery recycling center.', 'neutral', '2024-01-30 10:35:00'),
(16, 'customer', 'This is the second battery issue I''ve had. Your battery quality needs improvement.', 'negative', '2024-01-30 11:00:00'),
(16, 'agent', 'You''re right, and I''m sorry. I see your previous case about the swollen battery. I''m escalating both incidents to our quality team. As a goodwill gesture, I''m also adding a complimentary extra battery to your replacement order. You''ll receive both within 3 business days.', 'neutral', '2024-01-30 11:15:00'),
(16, 'customer', 'Okay, I appreciate the extra battery. Hopefully these ones last longer.', 'neutral', '2024-01-30 11:30:00');

-- Session 17: AgriScan 200 setup and first flight
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(17, 'customer', 'We just received our AgriScan 200 for our farm. Can you walk us through the initial setup for crop surveying?', 'neutral', '2024-01-31 14:00:00'),
(17, 'agent', 'Hi Priya! Congratulations on your AgriScan 200! I''d be happy to walk you through it. First, make sure you''ve charged all batteries and updated the firmware to the latest version via the AgriScan Pro app.', 'positive', '2024-01-31 14:03:00'),
(17, 'customer', 'Firmware is updated and batteries are charged. What''s next?', 'neutral', '2024-01-31 14:08:00'),
(17, 'agent', 'Great! For crop surveying: 1) Open the AgriScan Pro app, 2) Select "New Survey Mission", 3) Draw your field boundary on the map, 4) Set altitude (30m recommended for NDVI), 5) Set overlap (75% front, 65% side recommended), 6) The app auto-generates the flight path. Want to do a test flight first?', 'neutral', '2024-01-31 14:12:00'),
(17, 'customer', 'Yes, we''ll do a test on a small section. What does the multispectral sensor capture exactly?', 'neutral', '2024-01-31 14:18:00'),
(17, 'agent', 'The AgriScan''s multispectral sensor captures 5 bands: Red, Green, Blue, Red Edge, and Near-Infrared. The NDVI (crop health) maps are generated automatically from Red and NIR. You can also view individual band data for specific analysis like chlorophyll content or water stress.', 'neutral', '2024-01-31 14:25:00'),
(17, 'customer', 'This is exactly what we need. We''ll run the test mission this afternoon. Thanks for the clear walkthrough!', 'positive', '2024-01-31 14:35:00'),
(17, 'agent', 'You''re welcome! After your first mission, the processed maps appear in the app within about 15 minutes. Feel free to reach out if you have questions about interpreting the NDVI data. Good luck with the survey!', 'positive', '2024-01-31 14:45:00');

-- Session 18: SkyVision Pro lost drone - signal loss
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(18, 'customer', 'I lost my SkyVision Pro yesterday. Signal cut out at about 2km and the drone never came back. RTH didn''t activate. I am furious. This is a $1,200 drone!', 'negative', '2024-02-01 09:30:00'),
(18, 'agent', 'Marcus, I''m so sorry this happened. Losing a drone is extremely frustrating. Let me help you locate it. First, check the SkyVision app > Flight Records > Last Known Position. Do you see GPS coordinates for where contact was lost?', 'neutral', '2024-02-01 09:35:00'),
(18, 'customer', 'It shows the last position as somewhere over a wooded area about 2.3km from where I was standing. But I can''t get there easily — it''s dense forest.', 'negative', '2024-02-01 09:42:00'),
(18, 'agent', 'The drone should have triggered automatic RTH when signal was lost. Can you share the flight log so we can understand why it didn''t? Also, did you have the RTH altitude set above tree height?', 'neutral', '2024-02-01 09:48:00'),
(18, 'customer', 'I just checked and RTH altitude was set to the default 20 meters. The trees in that area are 30-40 meters tall. Could it have hit a tree?', 'neutral', '2024-02-01 09:55:00'),
(18, 'agent', 'That''s very likely what happened. With RTH set to 20m and trees at 30-40m, the drone would have attempted RTH but collided with the canopy. This is a critical safety setting — RTH altitude should always be set above the tallest obstacles in your area.', 'neutral', '2024-02-01 10:05:00'),
(18, 'customer', 'Why is the default set so low then?! The app should warn you about this. I want a replacement drone.', 'negative', '2024-02-01 10:15:00'),
(18, 'agent', 'You make an excellent point about the default RTH altitude — I''m logging this as a product improvement request. Unfortunately, signal loss due to range and RTH altitude settings aren''t covered under our standard warranty. However, I can offer you 30% off a replacement SkyVision Pro as a one-time courtesy.', 'neutral', '2024-02-01 10:30:00'),
(18, 'customer', 'That''s not good enough. Your default settings contributed to this loss. I want at least 50% off.', 'negative', '2024-02-01 10:40:00'),
(18, 'agent', 'Let me escalate this to my manager. Given the circumstances with the default RTH altitude, I''ve gotten approval for a 50% discount on a replacement SkyVision Pro. I''ll also help you set up proper failsafe settings when it arrives. Would that be acceptable?', 'neutral', '2024-02-01 10:50:00'),
(18, 'customer', 'Fine. Process the order. And please fix those defaults for future customers.', 'negative', '2024-02-01 11:00:00');

-- Session 19: DroneLink Controller won't pair (open)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(19, 'customer', 'My DroneLink Controller won''t pair with my AeroMax 4K. I''ve held the pairing button for 5 seconds like the manual says but nothing happens.', 'negative', '2024-02-02 15:00:00'),
(19, 'agent', 'Hello Elena! Let''s get this sorted. First, make sure both the controller and drone are powered on and within 1 meter of each other. Also, is the controller''s firmware up to date?', 'neutral', '2024-02-02 15:05:00'),
(19, 'customer', 'They''re right next to each other. Not sure about firmware — how do I check on the controller?', 'neutral', '2024-02-02 15:10:00'),
(19, 'agent', 'Connect the controller to your phone via USB. Open the SkyVision app, go to Controller > About > Firmware Version. The latest version is 4.1.2. Let me know what you see.', 'neutral', '2024-02-02 15:15:00');

-- Session 20: SurveyHawk X1 unstable hover (open)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(20, 'customer', 'Our SurveyHawk X1 is wobbling badly during hover. It''s oscillating side to side and the footage is unusable. We''ve recalibrated IMU and compass already.', 'negative', '2024-02-02 16:00:00'),
(20, 'agent', 'Hi Tyler! That oscillation could indicate a few things. When did this start? And have you checked all propellers for damage — even small nicks or cracks can cause instability.', 'neutral', '2024-02-02 16:03:00'),
(20, 'customer', 'Started after we replaced two propellers last week. We used third-party props because they were cheaper. Could that be the issue?', 'neutral', '2024-02-02 16:08:00'),
(20, 'agent', 'That''s very likely the cause. Third-party propellers often have slight balance differences that cause oscillation. The SurveyHawk''s flight controller is tuned for our OEM propellers. I strongly recommend using only genuine SkyVision propellers, especially on commercial drones where stability is critical.', 'neutral', '2024-02-02 16:11:00'),
(20, 'customer', 'We still have the original props. Let me swap them back and test. Are OEM replacements available for purchase?', 'neutral', '2024-02-02 16:15:00');

-- Session 21: AeroMax 4K propeller damage warranty
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(21, 'customer', 'One of the propellers on my AeroMax 4K snapped during a normal flight — no crash. It just broke mid-air and the drone emergency landed. This shouldn''t happen!', 'negative', '2024-02-03 10:00:00'),
(21, 'agent', 'Mei Lin, I''m glad the emergency landing system worked! A propeller snapping during normal flight is very unusual. Can you check the broken prop — is the break at the base where it attaches to the motor, or along the blade?', 'neutral', '2024-02-03 10:05:00'),
(21, 'customer', 'At the base. It looks like it cracked where the screw goes through.', 'neutral', '2024-02-03 10:12:00'),
(21, 'agent', 'That''s a stress fracture at the hub — this is a known issue on a small batch of AeroMax props from early production. Fully covered under warranty. I''m sending you a complete set of 4 replacement propellers (updated design with reinforced hubs) at no charge.', 'neutral', '2024-02-03 10:20:00'),
(21, 'customer', 'Good to hear it''s covered. That was scary though — what if it had been over water?', 'negative', '2024-02-03 10:30:00'),
(21, 'agent', 'Completely valid concern. The emergency landing system would still activate over water, though recovery would be difficult. I recommend inspecting propellers before each flight for any hairline cracks. The new reinforced props solve this issue. Shipping in 2-3 days.', 'neutral', '2024-02-03 10:45:00'),
(21, 'customer', 'Alright, I''ll wait for the replacements. Thanks.', 'neutral', '2024-02-03 11:00:00');

-- Session 22: SkyVision Pro obstacle avoidance feature request
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(22, 'customer', 'The SkyVision Pro is great but I wish the obstacle avoidance worked in all directions. It only detects obstacles in front and below. Any plans for side and rear sensors?', 'neutral', '2024-02-04 14:00:00'),
(22, 'agent', 'Hi Ryan! Great feedback. You''re right — the current SkyVision Pro has forward and downward obstacle avoidance. We''re actively developing the SkyVision Pro 2 which will have omnidirectional obstacle sensing (front, rear, sides, top, and bottom).', 'neutral', '2024-02-04 14:05:00'),
(22, 'customer', 'When is the Pro 2 coming out? And will there be a trade-in program for current Pro owners?', 'neutral', '2024-02-04 14:10:00'),
(22, 'agent', 'The SkyVision Pro 2 is planned for Q3 2024. We''re working on a trade-in program that would give Pro owners a significant discount. I''ll add you to the early notification list so you''re first to know when details are announced!', 'positive', '2024-02-04 14:15:00'),
(22, 'customer', 'Perfect! Sign me up for that notification. Excited to see the Pro 2!', 'positive', '2024-02-04 14:22:00'),
(22, 'agent', 'You''re on the list! Thanks for being a loyal SkyVision customer. Your feedback about omnidirectional sensing has been shared with the product team.', 'positive', '2024-02-04 14:30:00');

-- Session 23: FlightPack Battery won't charge
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(23, 'customer', 'My FlightPack Battery won''t charge at all. I plug it into the charger and the LED stays red for a second then turns off. Nothing happens after that.', 'negative', '2024-02-05 09:00:00'),
(23, 'agent', 'Hi Sofia! That behavior usually means the battery has entered deep discharge protection. How long has it been since you last used or charged this battery?', 'neutral', '2024-02-05 09:05:00'),
(23, 'customer', 'About 3 months. I forgot about it after the season ended.', 'neutral', '2024-02-05 09:10:00'),
(23, 'agent', 'When a LiPo battery sits uncharged for months, the voltage drops below the safe threshold and the BMS (Battery Management System) locks it out to prevent damage. Try this: press and hold the battery''s power button for 10 seconds to wake the BMS, then immediately connect the charger.', 'neutral', '2024-02-05 09:15:00'),
(23, 'customer', 'I held the button for 10 seconds, plugged in the charger, and... the LED is now blinking green! It seems to be charging!', 'positive', '2024-02-05 09:25:00'),
(23, 'agent', 'Excellent! It''s in trickle-charge mode to slowly bring the cells back up. It may take longer than normal to fully charge. Once full, check the battery health in the app — if it''s above 80%, the battery is fine. For the future, always store batteries at 40-60% charge and top them off every 2-3 months.', 'neutral', '2024-02-05 09:35:00'),
(23, 'customer', 'Got it. I''ll set a reminder. Thanks for saving my battery!', 'positive', '2024-02-05 09:45:00'),
(23, 'agent', 'Happy to help! The QuickCharge Hub actually has a storage mode that manages this automatically if you''re interested. Enjoy the new flying season!', 'positive', '2024-02-05 10:00:00');

-- Session 24: Scout Mini drone won't arm
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(24, 'customer', 'My Scout Mini won''t arm. I push the sticks down and inward but the motors don''t spin up. No error messages in the app either.', 'negative', '2024-02-06 11:00:00'),
(24, 'agent', 'Hi Nathan! Let''s troubleshoot this. A few things to check: 1) Is the battery fully seated and locked? 2) Are all propellers installed correctly (check the A/B markings)? 3) Is the firmware up to date?', 'neutral', '2024-02-06 11:05:00'),
(24, 'customer', 'Battery is locked. Let me check the props... Oh wait, I think two of them might be swapped. The A and B markings — do they need to match specific motors?', 'neutral', '2024-02-06 11:12:00'),
(24, 'agent', 'Yes! This is critical. "A" props go on motors marked "A" (front-left and rear-right), and "B" props go on "B" motors (front-right and rear-left). If they''re swapped, the pre-flight check detects the wrong rotation direction and refuses to arm as a safety measure.', 'neutral', '2024-02-06 11:18:00'),
(24, 'customer', 'That was it! I swapped two props and now it arms and flies perfectly. The markings are tiny though — hard to read.', 'positive', '2024-02-06 11:35:00'),
(24, 'agent', 'Glad that fixed it! You''re right about the markings being small. Tip: use a silver Sharpie to add a visible dot on all your "A" props or "B" props — makes it much easier to identify at a glance. Safe flights!', 'positive', '2024-02-06 11:45:00'),
(24, 'customer', 'Great tip! Thanks for the help!', 'positive', '2024-02-06 12:00:00');

-- Session 25: AgriScan 200 waypoint mission request
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(25, 'customer', 'Love the AgriScan 200! Just wanted to suggest adding the ability to save and repeat waypoint missions. Right now I have to re-draw the flight path every time I survey the same field.', 'neutral', '2024-02-07 13:00:00'),
(25, 'agent', 'Hi Hannah! Great news — this feature actually already exists! In the AgriScan Pro app, after completing a mission, go to Mission History > select your mission > "Save as Template." You can then reload it anytime from the Templates tab.', 'positive', '2024-02-07 13:05:00'),
(25, 'customer', 'Oh! I had no idea. That''s amazing! Can I also schedule missions to run automatically at certain times?', 'positive', '2024-02-07 13:10:00'),
(25, 'agent', 'Not yet, but automated scheduling is on our roadmap for the AgriScan platform! For now, you can pre-load a saved mission and launch it with one tap when you arrive at the field. I''ll log your interest in the scheduling feature.', 'neutral', '2024-02-07 13:15:00'),
(25, 'customer', 'The template feature is a game changer for us. Thanks for pointing it out! Also, a scheduled mission feature would be incredible for monitoring crop growth over time.', 'positive', '2024-02-07 13:22:00'),
(25, 'agent', 'Absolutely! Time-series crop monitoring is a key use case we''re designing scheduling around. Thanks for the valuable feedback — it helps us prioritize. Happy surveying!', 'positive', '2024-02-07 13:30:00');

-- Create indexes for better query performance
CREATE INDEX idx_chat_sessions_category ON chat_sessions(category);
CREATE INDEX idx_chat_sessions_status ON chat_sessions(status);
CREATE INDEX idx_chat_sessions_created_at ON chat_sessions(created_at);
CREATE INDEX idx_messages_session_id ON messages(session_id);
CREATE INDEX idx_messages_sentiment ON messages(sentiment);
CREATE INDEX idx_messages_created_at ON messages(created_at);

-- Create a view for session summaries
CREATE VIEW session_summaries AS
SELECT
    cs.id,
    cs.customer_id,
    c.name as customer_name,
    cs.product_id,
    p.name as product_name,
    p.category as product_category,
    cs.status,
    cs.category,
    cs.priority,
    cs.satisfaction_rating,
    cs.created_at,
    cs.resolved_at,
    COUNT(m.id) as message_count,
    EXTRACT(EPOCH FROM (cs.resolved_at - cs.created_at))/60 as resolution_time_minutes
FROM chat_sessions cs
LEFT JOIN customers c ON cs.customer_id = c.id
LEFT JOIN products p ON cs.product_id = p.id
LEFT JOIN messages m ON cs.id = m.session_id
GROUP BY cs.id, c.name, p.name, p.category;
