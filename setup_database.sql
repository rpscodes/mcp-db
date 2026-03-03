-- SkyVision Pro Ecosystem - Customer Support Chat Database Schema
-- Single-product ecosystem: SkyVision Pro drone + its accessories

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

-- Insert SkyVision Pro ecosystem products (5 products)
INSERT INTO products (name, category) VALUES
('SkyVision Pro', 'Drone'),
('FlightPack Battery 6000mAh', 'Battery'),
('DroneLink Controller', 'Controller'),
('VisionCam Gimbal', 'Camera & Gimbal'),
('QuickCharge Hub', 'Charger');

-- Insert customers (15 customers, unchanged)
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

-- Insert chat sessions (25 sessions across SkyVision Pro ecosystem)
-- Product distribution:
--   SkyVision Pro (1):        sessions 1,2,4,7,8,11,13,15,17,18,20,21,22,24 (14 sessions)
--   FlightPack Battery (2):   sessions 5,16,23,25 (4 sessions)
--   DroneLink Controller (3): sessions 6,14,19 (3 sessions)
--   VisionCam Gimbal (4):     sessions 3,12 (2 sessions)
--   QuickCharge Hub (5):      sessions 9,10 (2 sessions)

INSERT INTO chat_sessions (customer_id, product_id, status, category, priority, satisfaction_rating, created_at, resolved_at) VALUES
-- Session 1: SkyVision Pro motor failure (troubleshooting)
(1, 1, 'resolved', 'troubleshooting', 'high', 4, '2024-01-15 10:30:00', '2024-01-15 11:15:00'),
-- Session 2: SkyVision Pro compass calibration (support)
(2, 1, 'resolved', 'support', 'medium', 5, '2024-01-16 14:20:00', '2024-01-16 15:00:00'),
-- Session 3: VisionCam Gimbal image quality complaint (complaint)
(3, 4, 'resolved', 'complaint', 'high', 2, '2024-01-17 09:00:00', '2024-01-17 10:30:00'),
-- Session 4: SkyVision Pro positive feedback (feedback)
(4, 1, 'resolved', 'feedback', 'low', 5, '2024-01-18 16:30:00', '2024-01-18 16:50:00'),
-- Session 5: FlightPack Battery swollen/safety issue (complaint)
(5, 2, 'resolved', 'complaint', 'high', 3, '2024-01-19 11:00:00', '2024-01-19 12:30:00'),
-- Session 6: DroneLink Controller connectivity (troubleshooting)
(6, 3, 'resolved', 'troubleshooting', 'medium', 4, '2024-01-20 13:15:00', '2024-01-20 14:00:00'),
-- Session 7: SkyVision Pro firmware update failure (troubleshooting)
(7, 1, 'resolved', 'troubleshooting', 'high', 2, '2024-01-22 10:00:00', '2024-01-22 11:30:00'),
-- Session 8: SkyVision Pro GPS drift (troubleshooting)
(8, 1, 'resolved', 'troubleshooting', 'medium', 4, '2024-01-23 15:00:00', '2024-01-23 15:45:00'),
-- Session 9: QuickCharge Hub setup support (support)
(9, 5, 'resolved', 'support', 'low', 5, '2024-01-24 09:30:00', '2024-01-24 10:00:00'),
-- Session 10: QuickCharge Hub positive feedback (feedback)
(10, 5, 'resolved', 'feedback', 'low', 5, '2024-01-25 14:00:00', '2024-01-25 14:20:00'),
-- Session 11: SkyVision Pro RTH not working (troubleshooting)
(11, 1, 'resolved', 'troubleshooting', 'high', 2, '2024-01-26 10:30:00', '2024-01-26 12:00:00'),
-- Session 12: VisionCam Gimbal malfunction (complaint)
(12, 4, 'resolved', 'complaint', 'medium', 3, '2024-01-27 11:00:00', '2024-01-27 12:15:00'),
-- Session 13: SkyVision Pro warranty claim - cracked shell (support)
(13, 1, 'resolved', 'support', 'high', 4, '2024-01-28 16:00:00', '2024-01-28 17:00:00'),
-- Session 14: DroneLink Controller compatibility question (support)
(14, 3, 'resolved', 'support', 'low', 5, '2024-01-29 09:00:00', '2024-01-29 09:30:00'),
-- Session 15: SkyVision Pro feature request - follow-me mode (feedback)
(15, 1, 'resolved', 'feedback', 'low', 4, '2024-01-30 13:00:00', '2024-01-30 13:30:00'),
-- Session 16: FlightPack Battery fast drain (complaint)
(1, 2, 'resolved', 'complaint', 'high', 2, '2024-01-31 10:00:00', '2024-01-31 11:30:00'),
-- Session 17: SkyVision Pro setup and first flight (support)
(2, 1, 'resolved', 'support', 'medium', 5, '2024-02-01 14:00:00', '2024-02-01 14:45:00'),
-- Session 18: SkyVision Pro lost drone - signal loss (complaint)
(3, 1, 'resolved', 'complaint', 'high', 1, '2024-02-02 09:30:00', '2024-02-02 11:00:00'),
-- Session 19: DroneLink Controller won't pair (open)
(4, 3, 'open', 'troubleshooting', 'medium', NULL, '2024-02-03 15:00:00', NULL),
-- Session 20: SkyVision Pro unstable hover (open)
(5, 1, 'open', 'troubleshooting', 'high', NULL, '2024-02-04 16:00:00', NULL),
-- Session 21: SkyVision Pro propeller damage warranty (support)
(6, 1, 'resolved', 'support', 'medium', 3, '2024-02-05 10:00:00', '2024-02-05 11:00:00'),
-- Session 22: SkyVision Pro obstacle avoidance feature request (feedback)
(7, 1, 'resolved', 'feedback', 'low', 5, '2024-02-06 14:00:00', '2024-02-06 14:30:00'),
-- Session 23: FlightPack Battery won't charge (troubleshooting)
(8, 2, 'resolved', 'troubleshooting', 'high', 3, '2024-02-07 09:00:00', '2024-02-07 10:00:00'),
-- Session 24: SkyVision Pro drone won't arm (troubleshooting)
(9, 1, 'resolved', 'troubleshooting', 'high', 4, '2024-02-08 11:00:00', '2024-02-08 12:00:00'),
-- Session 25: FlightPack Battery storage tips (feedback)
(10, 2, 'resolved', 'feedback', 'low', 5, '2024-02-09 13:00:00', '2024-02-09 13:30:00');

-- Session 1: SkyVision Pro motor failure (UNCHANGED - already SkyVision Pro)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(1, 'customer', 'Hi, my SkyVision Pro''s rear-left motor is making a grinding noise and the drone is pulling to one side during flight. I''ve only had it for 3 months.', 'negative', '2024-01-15 10:30:00'),
(1, 'agent', 'Hello Alex! I''m sorry to hear about the motor issue. That grinding noise definitely isn''t normal. Can you tell me — did you notice this after a hard landing or crash, or did it start gradually?', 'neutral', '2024-01-15 10:32:00'),
(1, 'customer', 'No crashes. It started about a week ago as a slight vibration, and now it''s a clear grinding sound. The drone drifts left even in GPS mode.', 'negative', '2024-01-15 10:35:00'),
(1, 'agent', 'That sounds like a bearing failure in the motor. First, let''s confirm: power off the drone and try spinning each motor by hand. Does the affected motor feel rough or gritty compared to the others?', 'neutral', '2024-01-15 10:37:00'),
(1, 'customer', 'Yes! The rear-left motor feels gritty when I spin it. The other three spin smoothly.', 'neutral', '2024-01-15 10:42:00'),
(1, 'agent', 'That confirms a motor bearing failure. Since your SkyVision Pro is within the 12-month warranty period, we''ll send you a replacement motor at no charge. You can swap it yourself — it''s just 4 screws — or we can arrange a service center repair. Which do you prefer?', 'neutral', '2024-01-15 10:45:00'),
(1, 'customer', 'I can do it myself if you send a tutorial link. How long for shipping?', 'neutral', '2024-01-15 10:50:00'),
(1, 'agent', 'I''ll email you the motor replacement video guide right away. The replacement motor ships within 24 hours and should arrive in 2-3 business days. After installing, run a motor calibration from the SkyVision app before flying.', 'positive', '2024-01-15 10:52:00'),
(1, 'customer', 'Great, thanks for the quick help! I''ll watch for the email.', 'positive', '2024-01-15 10:55:00'),
(1, 'agent', 'You''re welcome, Alex! After installing the new motor, if you notice any vibration during hover test, let us know immediately. Happy flying!', 'positive', '2024-01-15 11:15:00');

-- Session 2: SkyVision Pro compass calibration (REWRITTEN - was Scout Mini)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(2, 'customer', 'I just got my SkyVision Pro and it keeps showing a "Compass Error" warning. I can''t take off. Help!', 'negative', '2024-01-16 14:20:00'),
(2, 'agent', 'Hi Priya! Welcome to the SkyVision family! The compass error on first flight is very common — the SkyVision Pro needs to be calibrated to your local magnetic environment. Have you done the compass calibration yet?', 'positive', '2024-01-16 14:22:00'),
(2, 'customer', 'No, I don''t know how to do that. The quick start guide didn''t mention it.', 'neutral', '2024-01-16 14:25:00'),
(2, 'agent', 'No worries! Here''s how: 1) Open the SkyVision app and tap Drone Settings > Sensors > Compass Calibration. 2) Hold the drone level and rotate 360 degrees slowly. 3) Then tilt it nose-down and rotate another 360 degrees. The app will confirm when done. Make sure you''re away from metal structures and cars.', 'neutral', '2024-01-16 14:28:00'),
(2, 'customer', 'I''m in a parking garage. Could that be the problem?', 'neutral', '2024-01-16 14:32:00'),
(2, 'agent', 'Absolutely! Parking garages have tons of metal rebar and structures that interfere with the compass. Move to an open field or park away from metal objects and power lines, then try the calibration again.', 'neutral', '2024-01-16 14:35:00'),
(2, 'customer', 'That worked perfectly! I went to the park and calibrated it. The SkyVision Pro is flying great now. Thank you so much!', 'positive', '2024-01-16 14:50:00'),
(2, 'agent', 'Wonderful! Pro tip: you may need to recalibrate when you travel to a new location far from home, as the magnetic field changes. Enjoy your SkyVision Pro! Feel free to reach out anytime.', 'positive', '2024-01-16 15:00:00');

-- Session 3: VisionCam Gimbal image quality complaint (REWRITTEN - was AeroMax 4K camera)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(3, 'customer', 'I bought the VisionCam Gimbal upgrade for my SkyVision Pro and I''m very disappointed. The image quality is noticeably worse than what was advertised. Everything looks washed out and soft.', 'negative', '2024-01-17 09:00:00'),
(3, 'agent', 'I''m sorry to hear that, Marcus. Let''s look into this. Can you confirm what recording settings you''re using? Go to Camera Settings and tell me the resolution, frame rate, and color profile.', 'neutral', '2024-01-17 09:03:00'),
(3, 'customer', 'It says 4K at 30fps, color profile is set to "Normal".', 'neutral', '2024-01-17 09:07:00'),
(3, 'agent', 'Try switching the color profile to "D-Log" — this is a flat profile that captures more dynamic range and is meant for color grading in post. Also, set the white balance manually instead of auto. What lighting conditions are you filming in?', 'neutral', '2024-01-17 09:10:00'),
(3, 'customer', 'Mostly outdoor daytime shots. But honestly, I shouldn''t need to do post-production on a gimbal upgrade. The sample footage on your website looks amazing straight out of camera.', 'negative', '2024-01-17 09:15:00'),
(3, 'agent', 'You make a fair point. The "Vivid" color profile should give you much better out-of-camera results. Also, make sure the gimbal lens is clean and the protective film has been removed — there''s a small film on the lens that''s easy to miss.', 'neutral', '2024-01-17 09:20:00'),
(3, 'customer', 'Oh wait... there was a lens film! I just peeled it off. Let me try some test shots.', 'neutral', '2024-01-17 09:40:00'),
(3, 'customer', 'Okay the lens film fixed the blurriness but the colors are still flat compared to your marketing videos. I''m going to return the gimbal.', 'negative', '2024-01-17 10:00:00'),
(3, 'agent', 'I understand your frustration. I''ve initiated a return for the VisionCam Gimbal. You''ll receive a prepaid shipping label via email. The refund will process within 5-7 business days of receiving the unit. I''ll also pass your feedback about the color quality to our product team.', 'neutral', '2024-01-17 10:15:00'),
(3, 'customer', 'Fine. Thanks for trying to help at least.', 'negative', '2024-01-17 10:30:00');

-- Session 4: SkyVision Pro positive feedback (UNCHANGED)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(4, 'customer', 'I just wanted to say the SkyVision Pro is the best drone I''ve ever owned. The flight stability is incredible even in 20mph wind!', 'positive', '2024-01-18 16:30:00'),
(4, 'agent', 'Thank you so much for the kind words, Elena! We''re thrilled you''re enjoying your SkyVision Pro. The advanced IMU and triple-redundant GPS really shine in windy conditions. What do you mainly use it for?', 'positive', '2024-01-18 16:35:00'),
(4, 'customer', 'Real estate photography mostly. The 45-minute flight time is a game changer — I can cover multiple properties on a single battery. And the obstacle avoidance has saved me from trees more than once!', 'positive', '2024-01-18 16:40:00'),
(4, 'agent', 'Real estate is one of our favorite use cases! Have you tried the Hyperlapse and Waypoint Mission modes? They''re perfect for creating cinematic property tours. Also, we''re releasing a firmware update next month with improved ActiveTrack.', 'positive', '2024-01-18 16:43:00'),
(4, 'customer', 'I haven''t tried waypoints yet — I''ll look into that! Looking forward to the update.', 'positive', '2024-01-18 16:45:00'),
(4, 'agent', 'You''ll love it for real estate! Use code SKYLOYAL15 for 15% off your next accessory purchase. Thanks for being a valued SkyVision customer!', 'positive', '2024-01-18 16:48:00'),
(4, 'customer', 'Awesome, thanks! I might grab an extra battery.', 'positive', '2024-01-18 16:50:00');

-- Session 5: FlightPack Battery swollen (UNCHANGED - already FlightPack Battery)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(5, 'customer', 'I noticed my FlightPack Battery 6000mAh is bulging on one side. It doesn''t sit flat anymore. Is this dangerous?', 'negative', '2024-01-19 11:00:00'),
(5, 'agent', 'Tyler, thank you for contacting us — this is important. A swollen LiPo battery is a safety concern. Please stop using it immediately and do NOT charge it. Can you tell me how old the battery is and how you''ve been storing it?', 'neutral', '2024-01-19 11:03:00'),
(5, 'customer', 'I''ve had it about 6 months. I usually just leave it in the SkyVision Pro after flying. Sometimes it sits for a couple weeks between flights.', 'neutral', '2024-01-19 11:07:00'),
(5, 'agent', 'Leaving a LiPo fully charged or fully depleted for extended periods can cause swelling. For long-term storage, batteries should be at around 50% charge. That said, a battery swelling at 6 months is concerning — this is covered under warranty.', 'neutral', '2024-01-19 11:10:00'),
(5, 'customer', 'Great. How do I dispose of the swollen one? And how do I get a replacement?', 'neutral', '2024-01-19 11:15:00'),
(5, 'agent', 'DO NOT throw it in regular trash. Take it to a battery recycling center or electronics store that accepts LiPo batteries. We''ll ship a free replacement under warranty. I''m processing that now. You''ll receive it in 3-5 business days.', 'neutral', '2024-01-19 11:18:00'),
(5, 'customer', 'Alright. It''s frustrating that the battery didn''t last even 6 months though. I expect better from a $90 battery.', 'negative', '2024-01-19 11:30:00'),
(5, 'agent', 'I completely understand. I''ll flag this with our battery team. With the replacement, I recommend using the storage mode feature in the SkyVision app — it automatically discharges the battery to storage level after your flight. That will extend battery life significantly.', 'neutral', '2024-01-19 11:35:00'),
(5, 'customer', 'Okay, I''ll try that. Thanks for the help.', 'neutral', '2024-01-19 12:30:00');

-- Session 6: DroneLink Controller connectivity (UNCHANGED - already DroneLink Controller)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(6, 'customer', 'My DroneLink Controller keeps losing connection to my SkyVision Pro at only 500 meters. The spec says 5km range!', 'negative', '2024-01-20 13:15:00'),
(6, 'agent', 'Hi Mei Lin! That''s well below the expected range. Let me help troubleshoot. A few questions: Are you flying in an urban area? And are the controller''s antennas fully extended and pointed toward the drone?', 'neutral', '2024-01-20 13:18:00'),
(6, 'customer', 'I''m in a suburban neighborhood. The antennas are up. I also notice a lot of interference warnings in the app.', 'neutral', '2024-01-20 13:22:00'),
(6, 'agent', 'Suburban areas often have heavy WiFi interference on 2.4GHz. Try switching the controller to 5.8GHz mode: go to Controller Settings > Transmission > Frequency Band and select 5.8GHz. It has shorter max range but much less interference in populated areas.', 'neutral', '2024-01-20 13:25:00'),
(6, 'customer', 'Switched to 5.8GHz and the interference warnings went away. I''ll test range this weekend. Thanks!', 'positive', '2024-01-20 13:40:00'),
(6, 'agent', 'Great! On 5.8GHz in suburban areas you should get 2-3km reliably. Also make sure your DroneLink Controller firmware is up to date — our latest update improved signal stability. Happy flying!', 'positive', '2024-01-20 14:00:00');

-- Session 7: SkyVision Pro firmware update failure (REWRITTEN - was AgriScan 200)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(7, 'customer', 'I tried updating my SkyVision Pro firmware and it failed at 60%. Now the drone won''t turn on at all. This is a $1,200 drone!', 'negative', '2024-01-22 10:00:00'),
(7, 'agent', 'I''m very sorry about this, Ryan. A failed firmware update can sometimes put the drone in a bricked state. Let''s try a recovery. Do you see any LED lights at all when you power on?', 'neutral', '2024-01-22 10:05:00'),
(7, 'customer', 'The LEDs blink red three times and then nothing. I can''t connect via the app either.', 'negative', '2024-01-22 10:10:00'),
(7, 'agent', 'Three red blinks indicates the flight controller is in recovery mode. Here''s what to do: 1) Download the SkyVision Firmware Recovery Tool from our website. 2) Connect the drone to your computer via USB-C. 3) Run the recovery tool and select "Force Flash Firmware."', 'neutral', '2024-01-22 10:15:00'),
(7, 'customer', 'I don''t have a USB-C cable that fits. The port on the SkyVision Pro looks different from standard USB-C.', 'negative', '2024-01-22 10:22:00'),
(7, 'agent', 'The SkyVision Pro uses a locking USB-C connector to prevent disconnection during updates. A standard USB-C cable should still fit — just push firmly until it clicks. If you''re still unable to connect, we need to bring this in for service.', 'neutral', '2024-01-22 10:30:00'),
(7, 'customer', 'I tried a standard cable and it doesn''t click in. I need my drone for a shoot next week. This is really bad timing.', 'negative', '2024-01-22 10:40:00'),
(7, 'agent', 'I understand the urgency. I''m escalating this to priority service. We''ll arrange next-day pickup and aim for 48-hour turnaround repair at no charge since this was a firmware issue on our end. I''ll email you the shipping details within the hour.', 'neutral', '2024-01-22 10:50:00'),
(7, 'customer', 'Alright, that''s the best option I guess. Please make it fast.', 'negative', '2024-01-22 11:00:00'),
(7, 'agent', 'Absolutely. I''ve marked this as urgent priority. You''ll also receive a loaner SkyVision Pro if the repair takes longer than 48 hours. I''m truly sorry for the inconvenience.', 'neutral', '2024-01-22 11:30:00');

-- Session 8: SkyVision Pro GPS drift (REWRITTEN - was Scout Mini GPS)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(8, 'customer', 'My SkyVision Pro keeps drifting even in GPS mode. It won''t hold position and slowly moves east. I''ve tried calibrating the compass twice.', 'negative', '2024-01-23 15:00:00'),
(8, 'agent', 'Hi Sofia! GPS drift can have a few causes. First, how many GPS satellites does the app show when you''re flying? You need at least 10 for stable positioning on the SkyVision Pro.', 'neutral', '2024-01-23 15:03:00'),
(8, 'customer', 'It shows 7-8 satellites usually.', 'neutral', '2024-01-23 15:08:00'),
(8, 'agent', 'That''s marginal. Try waiting 2-3 minutes after power-on before taking off — this gives the GPS time to acquire more satellites. Also, check for a firmware update — version 2.4.1 improved GPS accuracy significantly on the SkyVision Pro.', 'neutral', '2024-01-23 15:12:00'),
(8, 'customer', 'I''m on version 2.3.0. Let me update and try again.', 'neutral', '2024-01-23 15:20:00'),
(8, 'customer', 'Updated and waited longer before takeoff. Now showing 12 satellites and the hover is rock solid! Thanks!', 'positive', '2024-01-23 15:35:00'),
(8, 'agent', 'Excellent! The firmware update added GLONASS satellite support in addition to GPS, which is why you''re seeing more satellites now. Enjoy your SkyVision Pro!', 'positive', '2024-01-23 15:45:00');

-- Session 9: QuickCharge Hub setup (UNCHANGED)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(9, 'customer', 'Just got the QuickCharge Hub. How many batteries can I charge at once and does it work with all SkyVision batteries?', 'neutral', '2024-01-24 09:30:00'),
(9, 'agent', 'Hi Nathan! Great choice! The QuickCharge Hub charges up to 4 FlightPack batteries simultaneously. It''s compatible with all SkyVision battery models including the 4000mAh, 6000mAh, and the new 8000mAh Pro batteries.', 'positive', '2024-01-24 09:33:00'),
(9, 'customer', 'Perfect! How long does it take to fully charge four 6000mAh batteries?', 'neutral', '2024-01-24 09:38:00'),
(9, 'agent', 'Charging 4 batteries sequentially takes about 3 hours total (45 minutes each). The hub charges them in order of charge level — the most charged battery goes first so it''s ready sooner. You can also set it to storage charge mode for long-term storage.', 'positive', '2024-01-24 09:42:00'),
(9, 'customer', 'That''s really smart. Love the design too. Thanks for the info!', 'positive', '2024-01-24 09:50:00'),
(9, 'agent', 'You''re welcome! One tip: the hub has a built-in display that shows battery health over time. Keep an eye on it to know when batteries need replacing. Happy flying!', 'positive', '2024-01-24 10:00:00');

-- Session 10: QuickCharge Hub positive feedback (REWRITTEN - was AeroMax 4K feedback)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(10, 'customer', 'Just wanted to drop some positive feedback — the QuickCharge Hub is a fantastic accessory. Being able to charge all my SkyVision Pro batteries at once is a game changer. The build quality is solid too!', 'positive', '2024-01-25 14:00:00'),
(10, 'agent', 'Thank you so much, Hannah! That''s great to hear. The QuickCharge Hub was designed specifically to keep SkyVision Pro pilots in the air. Have you tried the storage mode feature for when you''re not flying regularly?', 'positive', '2024-01-25 14:05:00'),
(10, 'customer', 'Yes! The storage mode is brilliant. I''m a real estate photographer and I fly my SkyVision Pro almost daily. On weekends the hub keeps my batteries at storage level automatically. Such a thoughtful feature.', 'positive', '2024-01-25 14:10:00'),
(10, 'agent', 'We love hearing from professional users! The battery health monitoring display is another feature you''ll appreciate over time — it tracks cycle counts and cell health. Thanks for the wonderful feedback!', 'positive', '2024-01-25 14:15:00'),
(10, 'customer', 'That display has already helped me identify one battery that was degrading. Great product all around. Thanks!', 'positive', '2024-01-25 14:20:00');

-- Session 11: SkyVision Pro RTH not working (REWRITTEN - was SurveyHawk X1)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(11, 'customer', 'Serious issue: my SkyVision Pro''s Return-to-Home failed during a shoot. The drone just kept flying away and I had to manually take over. This is unacceptable for a $1,200 drone!', 'negative', '2024-01-26 10:30:00'),
(11, 'agent', 'Carlos, I completely understand your concern — RTH reliability is critical. Let me look into this. Was the RTH triggered automatically (low battery) or manually?', 'neutral', '2024-01-26 10:33:00'),
(11, 'customer', 'Low battery RTH. Battery hit 25% and it started RTH but then just flew in the wrong direction. I panicked and switched to manual.', 'negative', '2024-01-26 10:38:00'),
(11, 'agent', 'That''s very concerning. This can happen if the home point wasn''t properly set or if there was compass interference at the takeoff location. Can you check the flight log in the app? Go to Flight Records > select the flight > View Log. What does the home point status show at takeoff?', 'neutral', '2024-01-26 10:42:00'),
(11, 'customer', 'It says "Home Point Updated: GPS Accuracy 4.2m." That seems fine.', 'neutral', '2024-01-26 10:50:00'),
(11, 'agent', 'The GPS accuracy was fine, but I suspect compass interference at the location. Were you near any large metal structures, power lines, or heavy equipment? I''d like to pull your flight log for engineering analysis. Can you export it and email it to support@skyvisiondrones.com?', 'neutral', '2024-01-26 11:00:00'),
(11, 'customer', 'I was shooting near some construction equipment. I''ll send the log, but I need assurance this won''t happen again. I can''t lose a $1,200 drone on a job.', 'negative', '2024-01-26 11:15:00'),
(11, 'agent', 'Completely understood. I recommend: 1) Always do compass calibration at each new location, 2) Set a failsafe altitude higher than surrounding obstacles, 3) Update to firmware 3.2.0 which has improved RTH path planning around magnetic interference. I''m also adding a free compass module upgrade to your account. We take reliability very seriously.', 'neutral', '2024-01-26 11:30:00'),
(11, 'customer', 'Okay, I''ll update the firmware and try the calibration steps. Send me the compass module.', 'neutral', '2024-01-26 12:00:00');

-- Session 12: VisionCam Gimbal malfunction (UNCHANGED - already VisionCam Gimbal)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(12, 'customer', 'My VisionCam Gimbal is tilting to the left and making a clicking noise. The video comes out tilted about 10 degrees.', 'negative', '2024-01-27 11:00:00'),
(12, 'agent', 'Hi Aisha! That sounds like a gimbal motor issue. Has the SkyVision Pro had any recent crashes or hard landings?', 'neutral', '2024-01-27 11:05:00'),
(12, 'customer', 'It had a minor tip-over during landing last week, but it didn''t seem like a big deal.', 'neutral', '2024-01-27 11:10:00'),
(12, 'agent', 'Even minor tip-overs can misalign the VisionCam Gimbal. Try this: power on the drone on a flat surface and go to Camera Settings > Gimbal > Auto Calibrate. This can often fix alignment issues from minor impacts.', 'neutral', '2024-01-27 11:15:00'),
(12, 'customer', 'I ran the auto calibration and the tilt is fixed, but the clicking noise is still there when panning left.', 'neutral', '2024-01-27 11:30:00'),
(12, 'agent', 'The clicking suggests a damaged gimbal roll motor. Since this resulted from a landing incident, it wouldn''t be covered under standard warranty. However, we offer gimbal repair service for $85. Would you like me to set that up?', 'neutral', '2024-01-27 11:45:00'),
(12, 'customer', 'That feels steep for what was barely a tip-over. But I need it working. Go ahead and set up the repair.', 'negative', '2024-01-27 12:00:00'),
(12, 'agent', 'I''ve set up the repair order for your VisionCam Gimbal. You''ll receive a prepaid shipping box within 2 days. Turnaround time is 5-7 business days. I''ve also applied a 15% discount bringing it to $72.25. For future landings, I recommend using the landing pad accessory for stability.', 'neutral', '2024-01-27 12:15:00');

-- Session 13: SkyVision Pro warranty claim - cracked shell (UNCHANGED)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(13, 'customer', 'My SkyVision Pro''s top shell has a hairline crack along the seam. I haven''t crashed it — it seems like a manufacturing defect. The crack appeared after normal use.', 'negative', '2024-01-28 16:00:00'),
(13, 'agent', 'Hi Jake! I''m sorry about that. We have seen a small batch of SkyVision Pros with a shell bonding issue. Can you send me a photo of the crack and your drone''s serial number? You can find it under the battery compartment.', 'neutral', '2024-01-28 16:05:00'),
(13, 'customer', 'Serial number is SVP-2024-08-14523. I''ll email the photo to support.', 'neutral', '2024-01-28 16:12:00'),
(13, 'agent', 'Thank you! I''ve confirmed your serial number falls within the affected batch. This is fully covered under our manufacturing defect warranty. We''ll send you a complete replacement shell assembly. Would you like to install it yourself or have us do it?', 'neutral', '2024-01-28 16:25:00'),
(13, 'customer', 'I''ll install it myself. Is it easy?', 'neutral', '2024-01-28 16:30:00'),
(13, 'agent', 'Yes, it''s straightforward — 8 screws and 2 ribbon cables. We''ll include illustrated instructions and the necessary screwdriver. The shell kit should arrive within 3-5 business days. Sorry again for the defect!', 'positive', '2024-01-28 16:40:00'),
(13, 'customer', 'No problem, these things happen. Appreciate the quick response and free replacement!', 'positive', '2024-01-28 17:00:00');

-- Session 14: DroneLink Controller compatibility (REWRITTEN - was PropGuard Set)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(14, 'customer', 'Quick question — does the DroneLink Controller work with the SkyVision Pro out of the box? I want to upgrade from the standard controller.', 'neutral', '2024-01-29 09:00:00'),
(14, 'agent', 'Hi Olivia! Yes, the DroneLink Controller is fully compatible with the SkyVision Pro. It also works with our other drone models. Great choice for upgrading your control experience!', 'positive', '2024-01-29 09:05:00'),
(14, 'customer', 'Does it affect range or latency compared to the standard controller?', 'neutral', '2024-01-29 09:10:00'),
(14, 'agent', 'The DroneLink Controller actually improves both! You get up to 5km range (vs 3km on the standard controller) and lower video latency. It also has a built-in screen and physical control sticks that feel much more precise. The only tradeoff is it''s slightly heavier.', 'neutral', '2024-01-29 09:15:00'),
(14, 'customer', 'Sounds good, I''ll order one. Thanks!', 'positive', '2024-01-29 09:20:00'),
(14, 'agent', 'You''re welcome! Pro tip: after pairing, go to Controller Settings > Stick Calibration to fine-tune the stick response curves. It makes a huge difference for smooth cinematic shots. Happy flying!', 'positive', '2024-01-29 09:30:00');

-- Session 15: SkyVision Pro feature request - follow-me mode (REWRITTEN - was Scout Mini)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(15, 'customer', 'Love my SkyVision Pro but I really wish the follow-me mode was more reliable. I use it for mountain biking and it keeps losing me on sharp turns. Any plans to improve this?', 'neutral', '2024-01-30 13:00:00'),
(15, 'agent', 'Hi Derek! Thanks for the feedback. The follow-me mode on the SkyVision Pro uses GPS-based tracking, which can struggle with rapid direction changes. We''re actively working on an improved ActiveTrack 3.0 that uses visual + GPS fusion for much better tracking.', 'neutral', '2024-01-30 13:05:00'),
(15, 'customer', 'Any ETA on that update? Also, can you add better obstacle avoidance during follow-me? That would be amazing for trail riding.', 'neutral', '2024-01-30 13:10:00'),
(15, 'agent', 'We''re targeting Q2 2024 for the ActiveTrack 3.0 update. It will include obstacle avoidance during tracking — the SkyVision Pro has the sensor hardware, we just need the software update. I''ll log your request for both features.', 'neutral', '2024-01-30 13:18:00'),
(15, 'customer', 'Q2 isn''t too far off. I''ll keep using it as-is until then. Thanks for passing along the feedback!', 'positive', '2024-01-30 13:25:00'),
(15, 'agent', 'Absolutely! Your feedback directly shapes our roadmap. We''ll send a notification when the update drops. Keep shredding those trails!', 'positive', '2024-01-30 13:30:00');

-- Session 16: FlightPack Battery fast drain (UNCHANGED - already FlightPack Battery)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(16, 'customer', 'My FlightPack Battery 6000mAh used to give me 40 minutes of flight on my SkyVision Pro. Now I''m getting barely 20 minutes. I''ve only had it 4 months and about 50 charge cycles.', 'negative', '2024-01-31 10:00:00'),
(16, 'agent', 'Hi Alex! A 50% drop in flight time after only 50 cycles is abnormal — these batteries are rated for 300+ cycles. Let me help diagnose. Can you check the battery health in the SkyVision app under Battery > Health Monitor?', 'neutral', '2024-01-31 10:05:00'),
(16, 'customer', 'It shows battery health at 68%. Cell voltages are 3.7V, 3.7V, 3.6V, 3.5V. That last cell seems low.', 'neutral', '2024-01-31 10:12:00'),
(16, 'agent', 'That confirms a weak cell. The 0.2V imbalance in cell 4 is causing the battery management system to cut off early to protect against over-discharge. This is a defective cell — not normal wear.', 'neutral', '2024-01-31 10:18:00'),
(16, 'customer', 'So it''s defective? I paid $90 for this battery and it lasted 4 months. Not happy.', 'negative', '2024-01-31 10:25:00'),
(16, 'agent', 'Completely understandable. This is covered under warranty. I''m sending a replacement battery immediately at no charge. Please stop using the current battery as an unbalanced cell can be a safety risk. Take it to a battery recycling center.', 'neutral', '2024-01-31 10:35:00'),
(16, 'customer', 'This is the second battery issue I''ve had. Your battery quality needs improvement.', 'negative', '2024-01-31 11:00:00'),
(16, 'agent', 'You''re right, and I''m sorry. I see your previous case about the swollen battery. I''m escalating both incidents to our quality team. As a goodwill gesture, I''m also adding a complimentary extra battery to your replacement order. You''ll receive both within 3 business days.', 'neutral', '2024-01-31 11:15:00'),
(16, 'customer', 'Okay, I appreciate the extra battery. Hopefully these ones last longer.', 'neutral', '2024-01-31 11:30:00');

-- Session 17: SkyVision Pro setup and first flight (REWRITTEN - was AgriScan 200)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(17, 'customer', 'We just received our SkyVision Pro. Can you walk us through the initial setup for aerial photography?', 'neutral', '2024-02-01 14:00:00'),
(17, 'agent', 'Hi Priya! Congratulations on your SkyVision Pro! I''d be happy to walk you through it. First, make sure you''ve charged all batteries and updated the firmware to the latest version via the SkyVision app.', 'positive', '2024-02-01 14:03:00'),
(17, 'customer', 'Firmware is updated and batteries are charged. What''s next?', 'neutral', '2024-02-01 14:08:00'),
(17, 'agent', 'Great! For your first flight: 1) Find an open area away from buildings and people, 2) Place the drone on a flat surface, 3) Power on the controller first, then the drone, 4) Wait for GPS lock (12+ satellites), 5) Compass calibrate if prompted, 6) Set your RTH altitude above nearby obstacles. Want to do a test hover first?', 'neutral', '2024-02-01 14:12:00'),
(17, 'customer', 'Yes, we''ll do a test hover. What camera settings do you recommend for real estate photos?', 'neutral', '2024-02-01 14:18:00'),
(17, 'agent', 'For real estate: shoot in RAW+JPEG, set white balance to "Sunny" or "Cloudy" depending on conditions, use the "Vivid" color profile for ready-to-use shots. Fly at 30-50m altitude for wide property shots. The SkyVision Pro''s 1-inch sensor captures excellent detail and dynamic range.', 'neutral', '2024-02-01 14:25:00'),
(17, 'customer', 'This is exactly what we need. We''ll run the test flight this afternoon. Thanks for the clear walkthrough!', 'positive', '2024-02-01 14:35:00'),
(17, 'agent', 'You''re welcome! After your first flight, feel free to reach out if you have questions about camera settings or flight modes. The Waypoint Mission mode is fantastic for repeatable property shots. Happy flying!', 'positive', '2024-02-01 14:45:00');

-- Session 18: SkyVision Pro lost drone - signal loss (UNCHANGED)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(18, 'customer', 'I lost my SkyVision Pro yesterday. Signal cut out at about 2km and the drone never came back. RTH didn''t activate. I am furious. This is a $1,200 drone!', 'negative', '2024-02-02 09:30:00'),
(18, 'agent', 'Marcus, I''m so sorry this happened. Losing a drone is extremely frustrating. Let me help you locate it. First, check the SkyVision app > Flight Records > Last Known Position. Do you see GPS coordinates for where contact was lost?', 'neutral', '2024-02-02 09:35:00'),
(18, 'customer', 'It shows the last position as somewhere over a wooded area about 2.3km from where I was standing. But I can''t get there easily — it''s dense forest.', 'negative', '2024-02-02 09:42:00'),
(18, 'agent', 'The drone should have triggered automatic RTH when signal was lost. Can you share the flight log so we can understand why it didn''t? Also, did you have the RTH altitude set above tree height?', 'neutral', '2024-02-02 09:48:00'),
(18, 'customer', 'I just checked and RTH altitude was set to the default 20 meters. The trees in that area are 30-40 meters tall. Could it have hit a tree?', 'neutral', '2024-02-02 09:55:00'),
(18, 'agent', 'That''s very likely what happened. With RTH set to 20m and trees at 30-40m, the drone would have attempted RTH but collided with the canopy. This is a critical safety setting — RTH altitude should always be set above the tallest obstacles in your area.', 'neutral', '2024-02-02 10:05:00'),
(18, 'customer', 'Why is the default set so low then?! The app should warn you about this. I want a replacement drone.', 'negative', '2024-02-02 10:15:00'),
(18, 'agent', 'You make an excellent point about the default RTH altitude — I''m logging this as a product improvement request. Unfortunately, signal loss due to range and RTH altitude settings aren''t covered under our standard warranty. However, I can offer you 30% off a replacement SkyVision Pro as a one-time courtesy.', 'neutral', '2024-02-02 10:30:00'),
(18, 'customer', 'That''s not good enough. Your default settings contributed to this loss. I want at least 50% off.', 'negative', '2024-02-02 10:40:00'),
(18, 'agent', 'Let me escalate this to my manager. Given the circumstances with the default RTH altitude, I''ve gotten approval for a 50% discount on a replacement SkyVision Pro. I''ll also help you set up proper failsafe settings when it arrives. Would that be acceptable?', 'neutral', '2024-02-02 10:50:00'),
(18, 'customer', 'Fine. Process the order. And please fix those defaults for future customers.', 'negative', '2024-02-02 11:00:00');

-- Session 19: DroneLink Controller won't pair (open) (REWRITTEN - was AeroMax 4K pairing)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(19, 'customer', 'My DroneLink Controller won''t pair with my SkyVision Pro. I''ve held the pairing button for 5 seconds like the manual says but nothing happens.', 'negative', '2024-02-03 15:00:00'),
(19, 'agent', 'Hello Elena! Let''s get this sorted. First, make sure both the DroneLink Controller and your SkyVision Pro are powered on and within 1 meter of each other. Also, is the controller''s firmware up to date?', 'neutral', '2024-02-03 15:05:00'),
(19, 'customer', 'They''re right next to each other. Not sure about firmware — how do I check on the controller?', 'neutral', '2024-02-03 15:10:00'),
(19, 'agent', 'Connect the DroneLink Controller to your phone via USB. Open the SkyVision app, go to Controller > About > Firmware Version. The latest version is 4.1.2. Let me know what you see.', 'neutral', '2024-02-03 15:15:00');

-- Session 20: SkyVision Pro unstable hover (open) (REWRITTEN - was SurveyHawk X1)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(20, 'customer', 'My SkyVision Pro is wobbling badly during hover. It''s oscillating side to side and the footage is unusable. I''ve recalibrated IMU and compass already.', 'negative', '2024-02-04 16:00:00'),
(20, 'agent', 'Hi Tyler! That oscillation could indicate a few things. When did this start? And have you checked all propellers for damage — even small nicks or cracks can cause instability on the SkyVision Pro.', 'neutral', '2024-02-04 16:03:00'),
(20, 'customer', 'Started after I replaced two propellers last week. I used third-party props because they were cheaper. Could that be the issue?', 'neutral', '2024-02-04 16:08:00'),
(20, 'agent', 'That''s very likely the cause. Third-party propellers often have slight balance differences that cause oscillation. The SkyVision Pro''s flight controller is tuned for our OEM propellers. I strongly recommend using only genuine SkyVision propellers for stability.', 'neutral', '2024-02-04 16:11:00'),
(20, 'customer', 'I still have the original props. Let me swap them back and test. Are OEM replacements available for purchase?', 'neutral', '2024-02-04 16:15:00');

-- Session 21: SkyVision Pro propeller damage warranty (REWRITTEN - was AeroMax 4K)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(21, 'customer', 'One of the propellers on my SkyVision Pro snapped during a normal flight — no crash. It just broke mid-air and the drone emergency landed. This shouldn''t happen!', 'negative', '2024-02-05 10:00:00'),
(21, 'agent', 'Mei Lin, I''m glad the emergency landing system worked! A propeller snapping during normal flight is very unusual. Can you check the broken prop — is the break at the base where it attaches to the motor, or along the blade?', 'neutral', '2024-02-05 10:05:00'),
(21, 'customer', 'At the base. It looks like it cracked where the screw goes through.', 'neutral', '2024-02-05 10:12:00'),
(21, 'agent', 'That''s a stress fracture at the hub — this is a known issue on a small batch of SkyVision Pro props from early production. Fully covered under warranty. I''m sending you a complete set of 4 replacement propellers (updated design with reinforced hubs) at no charge.', 'neutral', '2024-02-05 10:20:00'),
(21, 'customer', 'Good to hear it''s covered. That was scary though — what if it had been over water?', 'negative', '2024-02-05 10:30:00'),
(21, 'agent', 'Completely valid concern. The SkyVision Pro''s emergency landing system would still activate over water, though recovery would be difficult. I recommend inspecting propellers before each flight for any hairline cracks. The new reinforced props solve this issue. Shipping in 2-3 days.', 'neutral', '2024-02-05 10:45:00'),
(21, 'customer', 'Alright, I''ll wait for the replacements. Thanks.', 'neutral', '2024-02-05 11:00:00');

-- Session 22: SkyVision Pro obstacle avoidance feature request (UNCHANGED)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(22, 'customer', 'The SkyVision Pro is great but I wish the obstacle avoidance worked in all directions. It only detects obstacles in front and below. Any plans for side and rear sensors?', 'neutral', '2024-02-06 14:00:00'),
(22, 'agent', 'Hi Ryan! Great feedback. You''re right — the current SkyVision Pro has forward and downward obstacle avoidance. We''re actively developing the SkyVision Pro 2 which will have omnidirectional obstacle sensing (front, rear, sides, top, and bottom).', 'neutral', '2024-02-06 14:05:00'),
(22, 'customer', 'When is the Pro 2 coming out? And will there be a trade-in program for current Pro owners?', 'neutral', '2024-02-06 14:10:00'),
(22, 'agent', 'The SkyVision Pro 2 is planned for Q3 2024. We''re working on a trade-in program that would give Pro owners a significant discount. I''ll add you to the early notification list so you''re first to know when details are announced!', 'positive', '2024-02-06 14:15:00'),
(22, 'customer', 'Perfect! Sign me up for that notification. Excited to see the Pro 2!', 'positive', '2024-02-06 14:22:00'),
(22, 'agent', 'You''re on the list! Thanks for being a loyal SkyVision customer. Your feedback about omnidirectional sensing has been shared with the product team.', 'positive', '2024-02-06 14:30:00');

-- Session 23: FlightPack Battery won't charge (UNCHANGED - already FlightPack Battery)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(23, 'customer', 'My FlightPack Battery won''t charge at all. I plug it into the charger and the LED stays red for a second then turns off. Nothing happens after that.', 'negative', '2024-02-07 09:00:00'),
(23, 'agent', 'Hi Sofia! That behavior usually means the battery has entered deep discharge protection. How long has it been since you last used or charged this battery?', 'neutral', '2024-02-07 09:05:00'),
(23, 'customer', 'About 3 months. I forgot about it after the season ended.', 'neutral', '2024-02-07 09:10:00'),
(23, 'agent', 'When a LiPo battery sits uncharged for months, the voltage drops below the safe threshold and the BMS (Battery Management System) locks it out to prevent damage. Try this: press and hold the battery''s power button for 10 seconds to wake the BMS, then immediately connect the charger.', 'neutral', '2024-02-07 09:15:00'),
(23, 'customer', 'I held the button for 10 seconds, plugged in the charger, and... the LED is now blinking green! It seems to be charging!', 'positive', '2024-02-07 09:25:00'),
(23, 'agent', 'Excellent! It''s in trickle-charge mode to slowly bring the cells back up. It may take longer than normal to fully charge. Once full, check the battery health in the app — if it''s above 80%, the battery is fine. For the future, always store batteries at 40-60% charge and top them off every 2-3 months.', 'neutral', '2024-02-07 09:35:00'),
(23, 'customer', 'Got it. I''ll set a reminder. Thanks for saving my battery!', 'positive', '2024-02-07 09:45:00'),
(23, 'agent', 'Happy to help! The QuickCharge Hub actually has a storage mode that manages this automatically if you''re interested. Enjoy the new flying season!', 'positive', '2024-02-07 10:00:00');

-- Session 24: SkyVision Pro drone won't arm (REWRITTEN - was Scout Mini)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(24, 'customer', 'My SkyVision Pro won''t arm. I push the sticks down and inward but the motors don''t spin up. No error messages in the app either.', 'negative', '2024-02-08 11:00:00'),
(24, 'agent', 'Hi Nathan! Let''s troubleshoot this. A few things to check: 1) Is the battery fully seated and locked? 2) Are all propellers installed correctly (check the A/B markings)? 3) Is the firmware up to date?', 'neutral', '2024-02-08 11:05:00'),
(24, 'customer', 'Battery is locked. Let me check the props... Oh wait, I think two of them might be swapped. The A and B markings — do they need to match specific motors?', 'neutral', '2024-02-08 11:12:00'),
(24, 'agent', 'Yes! This is critical on the SkyVision Pro. "A" props go on motors marked "A" (front-left and rear-right), and "B" props go on "B" motors (front-right and rear-left). If they''re swapped, the pre-flight check detects the wrong rotation direction and refuses to arm as a safety measure.', 'neutral', '2024-02-08 11:18:00'),
(24, 'customer', 'That was it! I swapped two props and now the SkyVision Pro arms and flies perfectly. The markings are tiny though — hard to read.', 'positive', '2024-02-08 11:35:00'),
(24, 'agent', 'Glad that fixed it! You''re right about the markings being small. Tip: use a silver Sharpie to add a visible dot on all your "A" props or "B" props — makes it much easier to identify at a glance. Safe flights!', 'positive', '2024-02-08 11:45:00'),
(24, 'customer', 'Great tip! Thanks for the help!', 'positive', '2024-02-08 12:00:00');

-- Session 25: FlightPack Battery storage tips (REWRITTEN - was AgriScan 200 waypoint request)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(25, 'customer', 'I have 4 FlightPack batteries for my SkyVision Pro. What''s the best way to store them during the winter months when I''m not flying? I want to maximize their lifespan.', 'neutral', '2024-02-09 13:00:00'),
(25, 'agent', 'Hi Hannah! Great question — proper storage is key to battery longevity. Store your FlightPack batteries at 40-60% charge (about 3.8V per cell). Never store them fully charged or fully depleted. The SkyVision app has a "Storage Discharge" feature that automatically brings them to the ideal level.', 'positive', '2024-02-09 13:05:00'),
(25, 'customer', 'Oh! I didn''t know about that feature. What temperature should I store them at? My garage gets pretty cold in winter.', 'neutral', '2024-02-09 13:10:00'),
(25, 'agent', 'Store LiPo batteries at room temperature — ideally 15-25°C (59-77°F). Cold garages can damage the cells over time. A closet inside your home is perfect. Also, check the voltage every 2-3 months and top them off if they drop below 3.6V per cell.', 'neutral', '2024-02-09 13:15:00'),
(25, 'customer', 'The QuickCharge Hub storage mode handles the discharge automatically, right? I just got one of those.', 'positive', '2024-02-09 13:22:00'),
(25, 'agent', 'Yes! The QuickCharge Hub''s storage mode is the easiest way to manage this. Just pop all 4 batteries in, select storage mode, and it handles everything. It even monitors cell health while they''re stored. Perfect companion for your FlightPack batteries.', 'positive', '2024-02-09 13:30:00');

-- Insert additional customers (16-25)
INSERT INTO customers (name, email) VALUES
('Liam Torres', 'ltorres@email.com'),
('Zara Ahmed', 'zahmed@email.com'),
('Kenji Nakamura', 'knakamura@email.com'),
('Rachel Kim', 'rkim@email.com'),
('David Okafor', 'dokafor@email.com'),
('Emma Schmidt', 'eschmidt@email.com'),
('Andre Williams', 'awilliams@email.com'),
('Ava Martinez', 'avamartinez@email.com'),
('Chris Dubois', 'cdubois@email.com'),
('Maya Patel', 'mpatel@email.com');

-- Insert additional chat sessions (26-75, spanning July 2023 - January 2024)
-- Product distribution (new): SkyVision Pro (14), FlightPack Battery (12), DroneLink Controller (10), VisionCam Gimbal (8), QuickCharge Hub (6)
-- Category distribution (new): troubleshooting (15), support (12), complaint (10), feedback (13)
-- Status distribution (new): resolved (38), open (7), escalated (5)

INSERT INTO chat_sessions (customer_id, product_id, status, category, priority, satisfaction_rating, created_at, resolved_at) VALUES
-- Session 26: SkyVision Pro motor overheating (troubleshooting)
(16, 1, 'resolved', 'troubleshooting', 'high', 4, '2023-07-05 09:15:00', '2023-07-05 10:00:00'),
-- Session 27: FlightPack Battery not recognized (troubleshooting)
(17, 2, 'resolved', 'troubleshooting', 'high', 3, '2023-07-12 11:30:00', '2023-07-12 12:30:00'),
-- Session 28: DroneLink Controller button stuck (troubleshooting)
(18, 3, 'resolved', 'troubleshooting', 'medium', 4, '2023-07-20 14:00:00', '2023-07-20 14:45:00'),
-- Session 29: VisionCam Gimbal overheating (troubleshooting)
(19, 4, 'resolved', 'troubleshooting', 'medium', 3, '2023-07-28 10:00:00', '2023-07-28 11:00:00'),
-- Session 30: QuickCharge Hub fan noise (troubleshooting)
(20, 5, 'resolved', 'troubleshooting', 'low', 4, '2023-08-04 15:30:00', '2023-08-04 16:15:00'),
-- Session 31: SkyVision Pro insurance question (support)
(21, 1, 'resolved', 'support', 'low', 5, '2023-08-10 10:00:00', '2023-08-10 10:30:00'),
-- Session 32: FlightPack Battery airline regulations (support)
(22, 2, 'resolved', 'support', 'medium', 5, '2023-08-18 13:00:00', '2023-08-18 13:45:00'),
-- Session 33: DroneLink Controller custom button mapping (support)
(23, 3, 'resolved', 'support', 'low', 4, '2023-08-25 09:30:00', '2023-08-25 10:15:00'),
-- Session 34: VisionCam Gimbal lens replacement (support)
(24, 4, 'resolved', 'support', 'medium', 5, '2023-09-01 14:00:00', '2023-09-01 14:45:00'),
-- Session 35: QuickCharge Hub power requirements (support)
(25, 5, 'resolved', 'support', 'low', 4, '2023-09-08 11:00:00', '2023-09-08 11:30:00'),
-- Session 36: SkyVision Pro paint peeling (complaint)
(1, 1, 'resolved', 'complaint', 'medium', 2, '2023-09-15 10:30:00', '2023-09-15 11:30:00'),
-- Session 37: FlightPack Battery repeated failures (complaint)
(2, 2, 'resolved', 'complaint', 'high', 2, '2023-09-22 09:00:00', '2023-09-22 10:30:00'),
-- Session 38: DroneLink Controller stick drift (complaint)
(3, 3, 'resolved', 'complaint', 'medium', 3, '2023-09-28 15:00:00', '2023-09-28 16:00:00'),
-- Session 39: VisionCam Gimbal jello effect (complaint)
(4, 4, 'resolved', 'complaint', 'high', 2, '2023-10-05 10:00:00', '2023-10-05 11:30:00'),
-- Session 40: QuickCharge Hub scratches batteries (complaint, escalated)
(5, 5, 'escalated', 'complaint', 'high', 1, '2023-10-12 14:00:00', NULL),
-- Session 41: SkyVision Pro mobile app improvements (feedback)
(6, 1, 'resolved', 'feedback', 'low', 5, '2023-10-18 16:00:00', '2023-10-18 16:30:00'),
-- Session 42: FlightPack Battery hot-swap feature (feedback)
(7, 2, 'resolved', 'feedback', 'low', 4, '2023-10-25 11:00:00', '2023-10-25 11:30:00'),
-- Session 43: DroneLink Controller voice control (feedback)
(8, 3, 'resolved', 'feedback', 'low', 4, '2023-11-01 13:00:00', '2023-11-01 13:30:00'),
-- Session 44: VisionCam Gimbal night vision / low-light (feedback)
(9, 4, 'resolved', 'feedback', 'low', 5, '2023-11-08 10:00:00', '2023-11-08 10:30:00'),
-- Session 45: QuickCharge Hub multi-voltage support (feedback)
(10, 5, 'resolved', 'feedback', 'low', 4, '2023-11-15 14:00:00', '2023-11-15 14:30:00'),
-- Session 46: SkyVision Pro WiFi transfer slow (troubleshooting)
(11, 1, 'resolved', 'troubleshooting', 'medium', 3, '2023-11-20 09:00:00', '2023-11-20 10:00:00'),
-- Session 47: FlightPack Battery charge stops at 80% (troubleshooting)
(12, 2, 'resolved', 'troubleshooting', 'medium', 4, '2023-11-28 11:00:00', '2023-11-28 12:00:00'),
-- Session 48: DroneLink Controller screen flicker (troubleshooting)
(13, 3, 'resolved', 'troubleshooting', 'medium', 3, '2023-12-04 14:30:00', '2023-12-04 15:30:00'),
-- Session 49: VisionCam Gimbal ND filter issues (troubleshooting)
(14, 4, 'resolved', 'troubleshooting', 'medium', 4, '2023-12-10 10:00:00', '2023-12-10 10:45:00'),
-- Session 50: QuickCharge Hub LED errors (troubleshooting)
(15, 5, 'resolved', 'troubleshooting', 'low', 5, '2023-12-15 15:00:00', '2023-12-15 15:30:00'),
-- Session 51: SkyVision Pro registration help (support)
(16, 1, 'resolved', 'support', 'low', 5, '2023-12-20 10:00:00', '2023-12-20 10:30:00'),
-- Session 52: FlightPack Battery cycle count check (support)
(17, 2, 'resolved', 'support', 'low', 4, '2023-12-26 13:00:00', '2023-12-26 13:30:00'),
-- Session 53: DroneLink Controller screen brightness (support)
(18, 3, 'resolved', 'support', 'low', 5, '2024-01-01 11:00:00', '2024-01-01 11:30:00'),
-- Session 54: SkyVision Pro noise reduction request (feedback)
(19, 1, 'resolved', 'feedback', 'low', 4, '2024-01-02 14:00:00', '2024-01-02 14:30:00'),
-- Session 55: FlightPack Battery longer range request (feedback)
(20, 2, 'resolved', 'feedback', 'low', 5, '2024-01-03 09:00:00', '2024-01-03 09:30:00'),
-- Session 56: SkyVision Pro loud motors (complaint)
(21, 1, 'resolved', 'complaint', 'medium', 2, '2024-01-04 11:00:00', '2024-01-04 12:00:00'),
-- Session 57: FlightPack Battery unreliable (complaint)
(22, 2, 'resolved', 'complaint', 'high', 3, '2024-01-05 10:00:00', '2024-01-05 11:00:00'),
-- Session 58: DroneLink Controller build quality (complaint, escalated)
(23, 3, 'escalated', 'complaint', 'high', 1, '2024-01-06 09:00:00', NULL),
-- Session 59: VisionCam Gimbal marketing mismatch (complaint)
(24, 4, 'resolved', 'complaint', 'high', 2, '2024-01-06 15:00:00', '2024-01-06 16:00:00'),
-- Session 60: QuickCharge Hub USB broke (complaint)
(25, 5, 'resolved', 'complaint', 'medium', 2, '2024-01-07 10:00:00', '2024-01-07 11:00:00'),
-- Session 61: SkyVision Pro waypoint sharing (feedback)
(1, 1, 'resolved', 'feedback', 'low', 5, '2024-01-07 14:00:00', '2024-01-07 14:30:00'),
-- Session 62: SkyVision Pro geofencing issue (troubleshooting, open)
(2, 1, 'open', 'troubleshooting', 'high', NULL, '2024-01-08 09:00:00', NULL),
-- Session 63: FlightPack Battery smaller portable version (feedback)
(3, 2, 'resolved', 'feedback', 'low', 4, '2024-01-08 15:00:00', '2024-01-08 15:30:00'),
-- Session 64: DroneLink Controller API access (feedback)
(4, 3, 'resolved', 'feedback', 'low', 5, '2024-01-09 10:00:00', '2024-01-09 10:30:00'),
-- Session 65: VisionCam Gimbal waterproofing (feedback)
(5, 4, 'resolved', 'feedback', 'low', 4, '2024-01-09 14:00:00', '2024-01-09 14:30:00'),
-- Session 66: SkyVision Pro flight school recommendations (support)
(6, 1, 'resolved', 'support', 'low', 5, '2024-01-10 10:00:00', '2024-01-10 10:30:00'),
-- Session 67: FlightPack Battery cold weather drain (troubleshooting, open)
(7, 2, 'open', 'troubleshooting', 'medium', NULL, '2024-01-10 15:00:00', NULL),
-- Session 68: DroneLink Controller joystick drift (troubleshooting, open)
(8, 3, 'open', 'troubleshooting', 'medium', NULL, '2024-01-11 09:00:00', NULL),
-- Session 69: VisionCam Gimbal horizon drift (troubleshooting, open)
(9, 4, 'open', 'troubleshooting', 'medium', NULL, '2024-01-11 14:00:00', NULL),
-- Session 70: FlightPack Battery warranty dispute (support, escalated)
(10, 2, 'escalated', 'support', 'high', 1, '2024-01-12 09:00:00', NULL),
-- Session 71: SkyVision Pro persistent motor issue (troubleshooting, escalated)
(11, 1, 'escalated', 'troubleshooting', 'high', 2, '2024-01-12 14:00:00', NULL),
-- Session 72: DroneLink Controller firmware update help (support, open)
(12, 3, 'open', 'support', 'medium', NULL, '2024-01-13 10:00:00', NULL),
-- Session 73: SkyVision Pro value pack / social features request (feedback, escalated)
(13, 1, 'escalated', 'feedback', 'medium', 2, '2024-01-13 15:00:00', NULL),
-- Session 74: SkyVision Pro accessory compatibility (support, open)
(14, 1, 'open', 'support', 'low', NULL, '2024-01-14 10:00:00', NULL),
-- Session 75: FlightPack Battery mapping/surveying use case (feedback, open)
(15, 2, 'open', 'feedback', 'low', NULL, '2024-01-14 14:00:00', NULL);

-- Session 26: SkyVision Pro motor overheating (troubleshooting)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(26, 'customer', 'My SkyVision Pro''s front-right motor gets extremely hot after about 10 minutes of flight. I can barely touch it after landing. Is this normal?', 'negative', '2023-07-05 09:15:00'),
(26, 'agent', 'Hi Liam! Some warmth is normal, but if the motor is too hot to touch, that''s excessive. Are you flying in high temperatures or with heavy payloads? Also, check if that propeller spins freely when the drone is off.', 'neutral', '2023-07-05 09:18:00'),
(26, 'customer', 'It''s about 95°F outside and I''m using the standard camera. The prop spins freely but I notice it''s slightly wobbly.', 'neutral', '2023-07-05 09:25:00'),
(26, 'agent', 'A wobbly prop can cause the motor to work harder and overheat. Try replacing the propeller with a fresh one from your spare set. Also, in high temperatures, I''d recommend limiting flights to 20-25 minutes and letting the motors cool for 10 minutes between flights.', 'neutral', '2023-07-05 09:30:00'),
(26, 'customer', 'Swapped the prop and did a test flight. Motor temperature is much better now. The old prop must have been slightly bent. Thanks!', 'positive', '2023-07-05 09:50:00'),
(26, 'agent', 'Great fix! Even a tiny bend in a propeller creates imbalance and extra motor strain. I recommend inspecting props before every flight — especially after any hard landings. Happy flying!', 'positive', '2023-07-05 10:00:00');

-- Session 27: FlightPack Battery not recognized (troubleshooting)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(27, 'customer', 'I just bought a new FlightPack Battery 6000mAh and my SkyVision Pro doesn''t recognize it. The app shows "No Battery Detected" even though the LED on the battery is lit.', 'negative', '2023-07-12 11:30:00'),
(27, 'agent', 'Hi Zara! That''s frustrating. Let''s troubleshoot. First, remove the battery and check the contacts — are they clean and free of any plastic packaging film? Sometimes new batteries have a thin film over the contacts.', 'neutral', '2023-07-12 11:33:00'),
(27, 'customer', 'Contacts look clean, no film. The battery clicks into place firmly. My other battery works fine in the same drone.', 'neutral', '2023-07-12 11:40:00'),
(27, 'agent', 'Try this: with the new battery installed, press and hold the battery''s power button for 15 seconds. This forces a BMS reset on new batteries. Then power the drone on normally.', 'neutral', '2023-07-12 11:45:00'),
(27, 'customer', 'Did the 15-second hold. Now the app sees it! Shows 100% charge. Why did I need to do that?', 'positive', '2023-07-12 12:00:00'),
(27, 'agent', 'New FlightPack batteries sometimes ship in a deep sleep mode to protect them during shipping. The long press wakes the BMS and allows communication with the drone. This is a one-time step. Enjoy your extra flight time!', 'positive', '2023-07-12 12:30:00');

-- Session 28: DroneLink Controller button stuck (troubleshooting)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(28, 'customer', 'The C1 custom button on my DroneLink Controller is stuck. It feels like something is jammed underneath it. I''ve only had this controller for 2 months.', 'negative', '2023-07-20 14:00:00'),
(28, 'agent', 'Hi Kenji! Sorry about that. The C1 button can sometimes catch debris underneath. Try gently blowing compressed air around the button edges. Do NOT try to pry it open.', 'neutral', '2023-07-20 14:03:00'),
(28, 'customer', 'I tried compressed air and the button freed up! Some sand came out. I was flying at the beach last weekend.', 'positive', '2023-07-20 14:20:00'),
(28, 'agent', 'Beach sand is a common culprit! For beach flying, I recommend using a controller silicone cover — we sell them on our accessories page. It keeps sand and moisture out of the buttons and joystick mechanisms. Glad it''s working!', 'positive', '2023-07-20 14:30:00'),
(28, 'customer', 'Good tip. I''ll grab one of those covers. Thanks!', 'positive', '2023-07-20 14:45:00');

-- Session 29: VisionCam Gimbal overheating (troubleshooting)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(29, 'customer', 'My VisionCam Gimbal is showing a temperature warning after about 15 minutes of 4K recording. The video gets choppy and eventually stops recording. This happens every flight.', 'negative', '2023-07-28 10:00:00'),
(29, 'agent', 'Hi Rachel! Overheating during extended 4K recording is a known issue in high ambient temperatures. What''s the temperature where you''re flying? And are you recording continuously or in intervals?', 'neutral', '2023-07-28 10:05:00'),
(29, 'customer', 'It''s summer here, about 90°F. I''m recording continuously for real estate walkthroughs.', 'neutral', '2023-07-28 10:10:00'),
(29, 'agent', 'At 90°F with continuous 4K, the sensor generates significant heat. Try these: 1) Switch to 1080p at 60fps — still excellent quality but much less heat. 2) Record in 2-3 minute segments with short breaks. 3) A firmware update (v2.1.3) improved thermal management — make sure you''re on it.', 'neutral', '2023-07-28 10:18:00'),
(29, 'customer', 'I updated to 2.1.3 and switched to shorter recording segments. That helped a lot. Still wish it could handle continuous 4K though.', 'neutral', '2023-07-28 10:45:00'),
(29, 'agent', 'I understand. Our engineering team is aware and working on further thermal improvements. The next VisionCam model will have a larger heat sink specifically for extended 4K. For now, the segment approach is the best workaround. Sorry for the inconvenience!', 'neutral', '2023-07-28 11:00:00');

-- Session 30: QuickCharge Hub fan noise (troubleshooting)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(30, 'customer', 'My QuickCharge Hub has started making a loud buzzing/rattling noise from the internal fan. It''s really annoying — I can hear it from the other room.', 'negative', '2023-08-04 15:30:00'),
(30, 'agent', 'Hi David! A rattling fan usually means a loose fan bearing or debris caught in the fan. Is the noise constant or does it come and go?', 'neutral', '2023-08-04 15:33:00'),
(30, 'customer', 'It''s constant whenever the hub is charging batteries. Goes away when idle.', 'neutral', '2023-08-04 15:38:00'),
(30, 'agent', 'The fan only runs during charging, so that makes sense. Try placing the hub on a flat, hard surface — soft surfaces can block the bottom air intake and make the fan work harder. Also, gently tilt the hub side to side to dislodge any debris inside.', 'neutral', '2023-08-04 15:42:00'),
(30, 'customer', 'Moved it off the carpet onto my desk and the noise is way better. Not perfect, but much quieter. I didn''t realize it needed airflow underneath.', 'positive', '2023-08-04 16:00:00'),
(30, 'agent', 'Yes, the QuickCharge Hub draws cool air from the bottom vents. A hard, flat surface gives it proper airflow. If the noise returns or gets worse, let us know — we can replace the fan under warranty. Glad it''s better!', 'positive', '2023-08-04 16:15:00');

-- Session 31: SkyVision Pro insurance question (support)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(31, 'customer', 'I''m using my SkyVision Pro for commercial real estate photography. Do you offer any kind of insurance or protection plan? I''m worried about crashes on client properties.', 'neutral', '2023-08-10 10:00:00'),
(31, 'agent', 'Hi Emma! Great question. We offer SkyShield Protection which covers accidental damage including crashes, water damage, and flyaways for $149/year. It includes 2 replacements per year with a $75 deductible each.', 'positive', '2023-08-10 10:03:00'),
(31, 'customer', 'That sounds reasonable. Does it cover my VisionCam Gimbal and FlightPack batteries too?', 'neutral', '2023-08-10 10:08:00'),
(31, 'agent', 'SkyShield covers the drone and any SkyVision accessories registered to your account. For commercial use, I also recommend checking with your business insurance provider about drone liability coverage. We can provide documentation of your drone''s specs for their records.', 'neutral', '2023-08-10 10:15:00'),
(31, 'customer', 'Perfect. I''ll sign up for SkyShield and check with my insurance company. Thanks for the info!', 'positive', '2023-08-10 10:25:00'),
(31, 'agent', 'You''re welcome, Emma! You can sign up for SkyShield directly in the SkyVision app under Account > Protection Plans. If you need any documentation for your insurer, just reach out. Happy flying!', 'positive', '2023-08-10 10:30:00');

-- Session 32: FlightPack Battery airline regulations (support)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(32, 'customer', 'I''m flying internationally next week and want to bring my SkyVision Pro with 3 FlightPack batteries. What are the airline rules for carrying drone batteries?', 'neutral', '2023-08-18 13:00:00'),
(32, 'agent', 'Hi Andre! Important question. The FlightPack 6000mAh battery is 88.8Wh, which is under the 100Wh carry-on limit. Here are the rules: 1) Batteries must be in carry-on luggage, NEVER checked bags. 2) Each passenger can carry up to 2 spare batteries. 3) Battery terminals must be protected — use the included caps.', 'neutral', '2023-08-18 13:05:00'),
(32, 'customer', 'So I can only bring 2 spare batteries plus the one in the drone? That''s 3 total?', 'neutral', '2023-08-18 13:10:00'),
(32, 'agent', 'Correct — the one installed in the drone counts separately, so you can carry the drone with 1 battery installed plus 2 spares in carry-on. Total of 3. Also, discharge the spares to below 30% for safer transport. Some airlines have additional restrictions, so check with yours before flying.', 'neutral', '2023-08-18 13:18:00'),
(32, 'customer', 'Got it. I''ll discharge the spares and keep them in carry-on. Any tips for going through airport security with a drone?', 'neutral', '2023-08-18 13:25:00'),
(32, 'agent', 'Remove the drone from your bag and place it in a separate bin, like a laptop. Propellers can stay attached. Have your FAA registration card handy in the US. Internationally, check local drone laws at your destination — some countries require advance registration. We have a country guide at skyvisiondrones.com/travel.', 'positive', '2023-08-18 13:35:00'),
(32, 'customer', 'Super helpful. I''ll check the travel guide. Thanks!', 'positive', '2023-08-18 13:45:00');

-- Session 33: DroneLink Controller custom button mapping (support)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(33, 'customer', 'Can I remap the buttons on my DroneLink Controller? I want C1 to toggle between photo and video mode instead of the default gimbal tilt reset.', 'neutral', '2023-08-25 09:30:00'),
(33, 'agent', 'Hi Ava! Yes, the DroneLink Controller supports full button customization. Go to Controller Settings > Button Mapping > C1 and you''ll see a list of assignable functions. "Camera Mode Toggle" is one of the options.', 'positive', '2023-08-25 09:35:00'),
(33, 'customer', 'Found it! Can I also map C2 to start/stop recording? That way I can control everything without touching the screen.', 'neutral', '2023-08-25 09:42:00'),
(33, 'agent', 'Absolutely! Map C2 to "Record Toggle" in the same menu. You can also assign the scroll wheel to zoom if you want full hands-on-controller operation. Many pro users set it up exactly this way.', 'positive', '2023-08-25 09:50:00'),
(33, 'customer', 'This is exactly what I needed. The default mappings weren''t intuitive for my workflow. Thanks for the quick help!', 'positive', '2023-08-25 10:05:00'),
(33, 'agent', 'You''re welcome! Pro tip: you can save your button layout as a profile and switch between profiles for different shooting situations. Go to Button Mapping > Save Profile. Happy flying!', 'positive', '2023-08-25 10:15:00');

-- Session 34: VisionCam Gimbal lens replacement (support)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(34, 'customer', 'I scratched the lens on my VisionCam Gimbal. Is it replaceable or do I need to send in the whole gimbal? Can I buy just the lens?', 'neutral', '2023-09-01 14:00:00'),
(34, 'agent', 'Hi Chris! The VisionCam Gimbal lens is user-replaceable. We sell replacement lens modules for $45 on our accessories page. It''s a simple twist-off, twist-on swap — takes about 30 seconds.', 'positive', '2023-09-01 14:05:00'),
(34, 'customer', 'That''s great news! I thought I''d need to replace the whole $300 gimbal. Will a UV filter help prevent scratches in the future?', 'neutral', '2023-09-01 14:12:00'),
(34, 'agent', 'We offer a UV/protective filter specifically for the VisionCam Gimbal — $15 and it screws right on. It protects the lens and doesn''t affect image quality. Highly recommended, especially for field work.', 'positive', '2023-09-01 14:20:00'),
(34, 'customer', 'I''ll order the replacement lens and a UV filter. Thanks for saving me $255!', 'positive', '2023-09-01 14:30:00'),
(34, 'agent', 'Happy to help! When the new lens arrives, make sure to calibrate the gimbal after installation — go to Camera > Gimbal > Auto Calibrate. Enjoy!', 'positive', '2023-09-01 14:45:00');

-- Session 35: QuickCharge Hub power requirements (support)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(35, 'customer', 'I want to use my QuickCharge Hub on location for a shoot. What are the power requirements? Can I run it from a car inverter or portable generator?', 'neutral', '2023-09-08 11:00:00'),
(35, 'agent', 'Hi Maya! The QuickCharge Hub draws 180W at peak (charging 4 batteries simultaneously). It needs a pure sine wave power source — most car inverters work fine as long as they''re rated for at least 300W. Avoid modified sine wave inverters as they can damage the hub.', 'neutral', '2023-09-08 11:05:00'),
(35, 'customer', 'I have a 500W pure sine wave inverter in my car. That should work, right? Also, will it charge slower on inverter power?', 'neutral', '2023-09-08 11:12:00'),
(35, 'agent', 'A 500W pure sine wave inverter is perfect. Charging speed will be identical to wall power — the hub doesn''t throttle on inverter sources. Just make sure your car is running while charging to avoid draining your car battery.', 'neutral', '2023-09-08 11:18:00'),
(35, 'customer', 'Great, exactly what I needed to know. Thanks!', 'positive', '2023-09-08 11:25:00'),
(35, 'agent', 'You''re welcome! One more tip: we sell a DC car charger cable that plugs directly into your 12V outlet for single-battery charging without needing an inverter. It''s $35 on the accessories page. Great as a backup option!', 'positive', '2023-09-08 11:30:00');

-- Session 36: SkyVision Pro paint peeling (complaint)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(36, 'customer', 'The paint on my SkyVision Pro is peeling badly on the arms. I''ve only had it for 5 months and I keep it in the carrying case. This looks terrible for a $1,200 drone.', 'negative', '2023-09-15 10:30:00'),
(36, 'agent', 'Hi Alex, I''m sorry to hear about the paint peeling. That shouldn''t happen with normal use. Can you share your drone''s serial number so I can check if it''s from an affected production batch?', 'neutral', '2023-09-15 10:33:00'),
(36, 'customer', 'Serial number is SVP-2023-04-08921. The paint is literally flaking off in sheets on two of the arms.', 'negative', '2023-09-15 10:40:00'),
(36, 'agent', 'Your serial number falls within a batch that had a paint adhesion issue. This is a known cosmetic defect. We can send you replacement arm covers at no charge, or if you prefer, we can do a full repaint at our service center.', 'neutral', '2023-09-15 10:48:00'),
(36, 'customer', 'I''ll take the replacement arm covers. But honestly, the paint quality on a premium drone should be better. My previous cheaper drone never had this problem.', 'negative', '2023-09-15 11:00:00'),
(36, 'agent', 'You''re absolutely right, and I apologize. We''ve changed our paint process for newer production runs. I''m shipping the replacement covers with express delivery. You''ll also receive a $50 accessory credit for the inconvenience.', 'neutral', '2023-09-15 11:15:00'),
(36, 'customer', 'The credit helps. Thanks for addressing it.', 'neutral', '2023-09-15 11:30:00');

-- Session 37: FlightPack Battery repeated failures (complaint)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(37, 'customer', 'This is my THIRD FlightPack Battery that''s failed in under a year. The first swelled, the second had a dead cell, and now this one won''t charge past 60%. Your batteries are unreliable.', 'negative', '2023-09-22 09:00:00'),
(37, 'agent', 'Priya, I''m very sorry to hear this. Three failures is unacceptable and I completely understand your frustration. Let me pull up your account to review all three incidents.', 'neutral', '2023-09-22 09:05:00'),
(37, 'customer', 'I''ve spent $270 on batteries that keep dying. I take care of them — I use the storage mode, I don''t fly in extreme weather, I do everything right.', 'negative', '2023-09-22 09:12:00'),
(37, 'agent', 'You''ve been doing everything correctly. This failure rate is abnormal. I''m sending you two brand-new batteries from our latest production batch at no charge. We''ve improved quality control since your originals were manufactured. I''m also flagging your cases for our quality engineering team.', 'neutral', '2023-09-22 09:22:00'),
(37, 'customer', 'Two free batteries is fair. But if these fail too, I''m switching to a competitor. I can''t keep dealing with this.', 'negative', '2023-09-22 09:35:00'),
(37, 'agent', 'I completely understand. The new batch batteries have enhanced cell balancing and improved BMS firmware. If you experience any issues, contact me directly and we''ll expedite resolution. I''ve added my direct support email to your account notes.', 'neutral', '2023-09-22 10:00:00'),
(37, 'customer', 'Alright. I''ll give it one more chance. Ship the batteries.', 'neutral', '2023-09-22 10:30:00');

-- Session 38: DroneLink Controller stick drift (complaint)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(38, 'customer', 'My DroneLink Controller has developed serious stick drift on the right joystick. The drone slowly yaws left even when I''m not touching the stick. This is dangerous!', 'negative', '2023-09-28 15:00:00'),
(38, 'agent', 'Hi Marcus, stick drift is a serious safety concern and I agree this needs immediate attention. Have you tried recalibrating the sticks? Go to Controller Settings > Stick Calibration and follow the prompts.', 'neutral', '2023-09-28 15:05:00'),
(38, 'customer', 'I''ve recalibrated three times. It helps for about 5 minutes then the drift comes back. The joystick physically doesn''t center properly — I can see it sitting slightly off-center.', 'negative', '2023-09-28 15:12:00'),
(38, 'agent', 'If the joystick isn''t physically centering, that''s a hardware defect in the potentiometer. How old is the controller?', 'neutral', '2023-09-28 15:15:00'),
(38, 'customer', 'Eight months old. I paid $250 for this controller and the sticks are already failing? My $30 gaming controller lasted 3 years.', 'negative', '2023-09-28 15:22:00'),
(38, 'agent', 'This is covered under warranty. I''m processing a replacement DroneLink Controller. In the meantime, you can increase the deadzone in Controller Settings > Stick Deadzone to reduce drift sensitivity. Set it to 10% as a temporary fix.', 'neutral', '2023-09-28 15:35:00'),
(38, 'customer', 'The deadzone setting helps for now. How long for the replacement?', 'neutral', '2023-09-28 15:45:00'),
(38, 'agent', 'The replacement ships tomorrow and should arrive in 2-3 business days. You can keep using the current one with the deadzone adjustment until then. I''m sorry for the inconvenience.', 'neutral', '2023-09-28 16:00:00');

-- Session 39: VisionCam Gimbal jello effect (complaint)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(39, 'customer', 'I''m getting terrible jello effect in all my VisionCam Gimbal footage. The video looks like it''s wobbling like gelatin. I''m a professional videographer and this is completely unusable for client work.', 'negative', '2023-10-05 10:00:00'),
(39, 'agent', 'Hi Elena, jello effect is typically caused by vibrations reaching the camera sensor. Let me help diagnose. Are you using genuine SkyVision propellers and are they all in good condition?', 'neutral', '2023-10-05 10:05:00'),
(39, 'customer', 'Yes, genuine props, all looking fine. I''ve balanced them too. The jello is worst at lower altitudes and during forward flight. Hovering footage is mostly fine.', 'negative', '2023-10-05 10:12:00'),
(39, 'agent', 'Jello during forward flight but not hover usually means the gimbal dampeners are worn or too stiff. Check the rubber dampening balls where the gimbal mounts to the drone. Are any of them cracked or deformed?', 'neutral', '2023-10-05 10:18:00'),
(39, 'customer', 'Two of the four dampening balls are squished flat and one has a crack. These are only 6 months old though.', 'neutral', '2023-10-05 10:28:00'),
(39, 'agent', 'Worn dampeners are the cause. In hot climates they degrade faster. We sell replacement dampener sets for $12. However, given they wore out in only 6 months, I''ll send you a set for free plus a spare set. They''re easy to swap — just pop the old ones out and press the new ones in.', 'neutral', '2023-10-05 10:40:00'),
(39, 'customer', 'The footage quality from a $300 gimbal shouldn''t depend on $12 rubber balls that wear out every 6 months. Please improve the durability.', 'negative', '2023-10-05 11:00:00'),
(39, 'agent', 'Fair point, and I''ll pass that to our design team. The next-gen dampeners are actually silicone-based and rated for 18+ months. I''ll send you those instead. We''re committed to improving durability.', 'neutral', '2023-10-05 11:30:00');

-- Session 40: QuickCharge Hub scratches batteries (complaint, escalated)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(40, 'customer', 'Your QuickCharge Hub is scratching the finish on my FlightPack batteries every time I insert them. The battery slots have rough edges that gouge the battery casing. This is a design flaw.', 'negative', '2023-10-12 14:00:00'),
(40, 'agent', 'Hi Tyler, I''m sorry to hear this. Can you describe where exactly the scratches are occurring? Is it on the bottom or sides of the battery when you slide it into the slot?', 'neutral', '2023-10-12 14:05:00'),
(40, 'customer', 'Both sides. The plastic guides in the charging slots have sharp molding seams that scrape the batteries. Look, I know it''s cosmetic, but I paid $90 per battery and $120 for the hub. Basic quality control should catch this.', 'negative', '2023-10-12 14:12:00'),
(40, 'agent', 'You''re right, that''s a manufacturing quality issue. I can send you a replacement hub — our newer production run has smoother slot guides. Would you like that?', 'neutral', '2023-10-12 14:18:00'),
(40, 'customer', 'A replacement would have the same design. I want confirmation that this has been fixed in newer units before I accept a replacement. And I want my scratched batteries replaced too.', 'negative', '2023-10-12 14:30:00'),
(40, 'agent', 'I understand. Let me escalate this to our product quality team to confirm the fix is in place. Regarding the scratched batteries — the scratches are cosmetic and don''t affect performance, but I understand your concern. I''ll work on this with my manager and get back to you within 24 hours.', 'neutral', '2023-10-12 14:45:00'),
(40, 'customer', 'Fine, but I expect a real resolution. Not just platitudes.', 'negative', '2023-10-12 15:00:00');

-- Session 41: SkyVision Pro mobile app improvements (feedback)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(41, 'customer', 'Love my SkyVision Pro but the mobile app needs work. The map view is laggy, flight telemetry often freezes, and there''s no way to share flight paths with other pilots. Any plans for an app update?', 'neutral', '2023-10-18 16:00:00'),
(41, 'agent', 'Hi Mei Lin! Thank you for the detailed feedback. We''re actually in the middle of a major app redesign. Can you tell me which device you''re using? The lag issues vary by platform.', 'neutral', '2023-10-18 16:03:00'),
(41, 'customer', 'iPhone 13 Pro. The lag is mostly on the map when I have multiple flight logs loaded. And I really want a way to export and share waypoint missions — my photography group all has SkyVision Pros and we want to share flight paths for locations we scout.', 'neutral', '2023-10-18 16:08:00'),
(41, 'agent', 'Great input! Waypoint sharing is actually on our roadmap for the next major update (v4.0, expected Q1 2024). You''ll be able to export missions as files and share them with other SkyVision users. The map performance fix is coming sooner in v3.5. I''ve logged your feedback about telemetry freezing too.', 'positive', '2023-10-18 16:15:00'),
(41, 'customer', 'Q1 2024 for waypoint sharing would be amazing. Can you also add a social feature where we can share aerial photos directly from the app? Like a SkyVision community gallery?', 'positive', '2023-10-18 16:22:00'),
(41, 'agent', 'A community gallery is a fantastic idea! I''m adding that to our feature request tracker. Your feedback is exactly what shapes our product roadmap. Thank you, Mei Lin!', 'positive', '2023-10-18 16:30:00');

-- Session 42: FlightPack Battery hot-swap feature (feedback)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(42, 'customer', 'Quick suggestion: the FlightPack battery swap takes too long. You have to power down, wait for the drone to shut down completely, swap the battery, then boot up again. That''s 2 minutes of downtime. Can you add hot-swap capability?', 'neutral', '2023-10-25 11:00:00'),
(42, 'agent', 'Hi Ryan! That''s a feature many professional users request. Hot-swapping LiPo batteries has safety considerations — the flight controller needs to fully reset between batteries to ensure proper cell monitoring. However, we''re exploring a quick-swap mode that could cut the boot time in half.', 'neutral', '2023-10-25 11:05:00'),
(42, 'customer', 'Even cutting boot time in half would be great. When I''m doing surveys, every minute counts. I go through 6-8 batteries per session.', 'neutral', '2023-10-25 11:12:00'),
(42, 'agent', 'For high-volume operations like yours, the upcoming SkyVision Pro 2 is designed with fast-swap in mind — the target is under 30 seconds from swap to takeoff. I''ve logged your use case as supporting data for that feature priority.', 'positive', '2023-10-25 11:20:00'),
(42, 'customer', 'Under 30 seconds would be perfect. Looking forward to the Pro 2. Keep up the good work!', 'positive', '2023-10-25 11:30:00');

-- Session 43: DroneLink Controller voice control (feedback)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(43, 'customer', 'Has SkyVision considered adding voice control to the DroneLink Controller? It would be amazing to say things like "start recording" or "take photo" without taking my thumbs off the sticks.', 'neutral', '2023-11-01 13:00:00'),
(43, 'agent', 'Hi Sofia! Voice control is something we''ve been researching. The DroneLink Controller actually has a built-in microphone (used for the intercom feature) that could potentially support voice commands. It''s on our innovation roadmap.', 'neutral', '2023-11-01 13:05:00'),
(43, 'customer', 'I didn''t even know there was a microphone! If you add voice commands, please include: start/stop recording, take photo, return to home, and orbit mode. Those are the functions I reach for most during flight.', 'neutral', '2023-11-01 13:12:00'),
(43, 'agent', 'Excellent suggestions — those are exactly the high-priority commands we''d start with. The challenge is wind noise filtering, since you''re often outdoors. We''re testing noise-cancellation algorithms. I''ve logged your specific command requests.', 'neutral', '2023-11-01 13:20:00'),
(43, 'customer', 'Wind noise is a good point. Maybe a push-to-talk button combined with voice? Press C2 and speak the command? That way it only listens when you want it to.', 'positive', '2023-11-01 13:25:00'),
(43, 'agent', 'That''s a brilliant UX suggestion — push-to-talk would solve both the wind noise and false activation problems. I''m passing this directly to our UX team. Thank you for the thoughtful feedback!', 'positive', '2023-11-01 13:30:00');

-- Session 44: VisionCam Gimbal night vision / low-light (feedback)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(44, 'customer', 'The VisionCam Gimbal is great during the day, but the low-light performance is terrible. At dusk my footage is grainy and unusable. Any plans for a low-light or night vision version?', 'neutral', '2023-11-08 10:00:00'),
(44, 'agent', 'Hi Nathan! Low-light performance is limited by the current 1/2.3" sensor size. We''re developing a VisionCam Gimbal Pro with a larger 1" sensor that should dramatically improve low-light footage. Are you shooting professional twilight content?', 'neutral', '2023-11-08 10:05:00'),
(44, 'customer', 'Yes, I do real estate twilight photography — those golden hour and blue hour shots that sell houses. Right now I have to use a separate camera on a handheld gimbal for those. A drone-mounted low-light camera would be incredible.', 'positive', '2023-11-08 10:12:00'),
(44, 'agent', 'Real estate twilight shots are a huge market for us. The VisionCam Gimbal Pro will have a 1" sensor with f/2.8 aperture — roughly 4x better low-light performance. ETA is mid-2024. I''ve added your use case to the feedback for that product.', 'positive', '2023-11-08 10:20:00'),
(44, 'customer', 'Mid-2024 works for me. Will it be backwards compatible with the current SkyVision Pro?', 'neutral', '2023-11-08 10:25:00'),
(44, 'agent', 'Yes, it uses the same mounting system. It will be a direct swap with the current VisionCam Gimbal. We''ll also offer a trade-in discount for existing gimbal owners. Thanks for the great feedback!', 'positive', '2023-11-08 10:30:00');

-- Session 45: QuickCharge Hub multi-voltage support (feedback)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(45, 'customer', 'I travel internationally a lot for drone work. The QuickCharge Hub only works on 110V. Can you make a universal voltage version that works on 220-240V too? I have to carry a voltage converter everywhere.', 'neutral', '2023-11-15 14:00:00'),
(45, 'agent', 'Hi Hannah! That''s a great point for our international users. The current hub''s power supply is indeed 110V only. We''re working on a universal version (100-240V auto-switching) for our next production run.', 'neutral', '2023-11-15 14:05:00'),
(45, 'customer', 'When will the universal version be available? I''m heading to Europe and Australia next year and the voltage converter is bulky and heavy.', 'neutral', '2023-11-15 14:12:00'),
(45, 'agent', 'We''re targeting Q2 2024. In the meantime, you can actually replace just the power supply module — a third-party 180W universal laptop charger with the right connector works. I can send you the connector specifications if you''d like a temporary solution.', 'neutral', '2023-11-15 14:18:00'),
(45, 'customer', 'Yes, please send the specs! That would save me from carrying the heavy converter. And definitely log my request for the universal version.', 'positive', '2023-11-15 14:25:00'),
(45, 'agent', 'I''ll email you the power supply specifications right away. Your request is logged — you''re actually one of many international users asking for this. It''s a high priority for us. Thanks for the feedback!', 'positive', '2023-11-15 14:30:00');

-- Session 46: SkyVision Pro WiFi transfer slow (troubleshooting)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(46, 'customer', 'Transferring footage from my SkyVision Pro to my phone via WiFi is painfully slow. A 2GB file takes over 30 minutes. Is this normal? The spec says WiFi 6.', 'negative', '2023-11-20 09:00:00'),
(46, 'agent', 'Hi Carlos! That transfer speed is slower than expected. WiFi 6 should give you around 50-80 MB/s in ideal conditions. Let me help troubleshoot. Are you connecting directly to the drone''s WiFi or going through your home network?', 'neutral', '2023-11-20 09:05:00'),
(46, 'customer', 'Directly to the drone''s WiFi hotspot. My phone is an iPhone 14 Pro which supports WiFi 6.', 'neutral', '2023-11-20 09:10:00'),
(46, 'agent', 'Try this: go to Drone Settings > WiFi > Channel and switch from "Auto" to a specific 5GHz channel (I recommend channel 149 or 153). Auto mode often picks a congested channel. Also, make sure no other WiFi networks nearby are on the same channel.', 'neutral', '2023-11-20 09:18:00'),
(46, 'customer', 'Switched to channel 149 and the transfer speed jumped to about 1 minute for a 2GB file. That''s a massive improvement!', 'positive', '2023-11-20 09:40:00'),
(46, 'agent', 'Glad to hear it! The auto channel selection can be unreliable in areas with many WiFi networks. For fastest transfers, you can also use the USB-C cable connection for wired transfer speeds up to 200 MB/s.', 'positive', '2023-11-20 10:00:00');

-- Session 47: FlightPack Battery charge stops at 80% (troubleshooting)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(47, 'customer', 'My FlightPack Battery stops charging at exactly 80% every time. The charger LED turns green at 80% like it''s full. I''ve tried multiple chargers including the QuickCharge Hub — same result.', 'negative', '2023-11-28 11:00:00'),
(47, 'agent', 'Hi Aisha! That''s interesting that it stops at exactly 80% on multiple chargers. This is actually a feature — check your SkyVision app under Battery > Charge Settings. Is "Battery Longevity Mode" enabled?', 'neutral', '2023-11-28 11:05:00'),
(47, 'customer', 'Oh! Yes, Battery Longevity Mode is turned on. I don''t remember enabling that. What does it do?', 'neutral', '2023-11-28 11:10:00'),
(47, 'agent', 'Battery Longevity Mode limits charging to 80% to extend the overall lifespan of the battery. It can add hundreds of extra charge cycles. It may have been enabled by a firmware update. You can turn it off for full charges when you need maximum flight time, or leave it on for everyday use.', 'neutral', '2023-11-28 11:15:00'),
(47, 'customer', 'I turned it off and now the battery is charging to 100%. I''ll keep it on for regular use and disable it when I need full capacity for long shoots. Thanks for finding that!', 'positive', '2023-11-28 11:35:00'),
(47, 'agent', 'Perfect approach! Pro tip: charge to 100% only when you need maximum flight time, and leave Longevity Mode on the rest of the time. Your batteries will thank you with longer lifespans. Happy flying!', 'positive', '2023-11-28 12:00:00');

-- Session 48: DroneLink Controller screen flicker (troubleshooting)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(48, 'customer', 'The built-in screen on my DroneLink Controller keeps flickering during flight. It goes black for a split second randomly. Makes it really hard to frame shots.', 'negative', '2023-12-04 14:30:00'),
(48, 'agent', 'Hi Jake! Screen flickering can be caused by a loose display cable or a software issue. First, let''s rule out software: what firmware version is your controller running? Check Controller > About > Firmware.', 'neutral', '2023-12-04 14:35:00'),
(48, 'customer', 'Version 3.8.2.', 'neutral', '2023-12-04 14:38:00'),
(48, 'agent', 'Version 4.0.1 is available and addresses a known screen flicker bug on certain display panels. Update via the SkyVision app with the controller connected via USB. The update takes about 5 minutes.', 'neutral', '2023-12-04 14:42:00'),
(48, 'customer', 'Updating now... done. I''ll test it on my next flight and report back.', 'neutral', '2023-12-04 14:55:00'),
(48, 'agent', 'Sounds good! If the flicker persists after the update, it may be a hardware issue with the display ribbon cable — we can arrange a repair under warranty. Let us know how the next flight goes!', 'neutral', '2023-12-04 15:00:00'),
(48, 'customer', 'Just did a test flight — no flickering at all! The firmware update fixed it. Thanks!', 'positive', '2023-12-04 15:20:00'),
(48, 'agent', 'Excellent! Glad the update resolved it. That was a known bug that affected a subset of DroneLink Controllers. Happy flying, Jake!', 'positive', '2023-12-04 15:30:00');

-- Session 49: VisionCam Gimbal ND filter issues (troubleshooting)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(49, 'customer', 'I bought the ND filter set for my VisionCam Gimbal but the ND32 filter creates a weird purple fringe around bright objects. The ND8 and ND16 look fine. Is my ND32 defective?', 'negative', '2023-12-10 10:00:00'),
(49, 'agent', 'Hi Olivia! Purple fringing with an ND32 can happen with certain production batches. It''s caused by uneven coating on the filter glass. Can you check the serial number on the filter case? It''s a 6-digit code on the back of the packaging.', 'neutral', '2023-12-10 10:05:00'),
(49, 'customer', 'The code is NDF-042891.', 'neutral', '2023-12-10 10:10:00'),
(49, 'agent', 'That''s from a batch we identified with coating inconsistencies on the ND32. I''ll send you a replacement ND32 filter from our corrected batch at no charge. The ND8 and ND16 from that batch are fine, so keep using those.', 'neutral', '2023-12-10 10:18:00'),
(49, 'customer', 'Great, thanks. I need the ND32 for bright daylight shooting to get that cinematic motion blur. How long for the replacement?', 'neutral', '2023-12-10 10:25:00'),
(49, 'agent', 'It''ll ship today and arrive in 2-3 business days. Pro tip: for the brightest conditions, you can stack the ND8 with the ND16 for an effective ND128, which gives you even more motion blur options while waiting for the ND32 replacement.', 'positive', '2023-12-10 10:35:00'),
(49, 'customer', 'Stacking filters is a clever workaround! Thanks for the quick resolution.', 'positive', '2023-12-10 10:45:00');

-- Session 50: QuickCharge Hub LED errors (troubleshooting)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(50, 'customer', 'The LEDs on my QuickCharge Hub are showing a pattern I can''t find in the manual: slot 1 is solid red, slot 2 is blinking orange, and slots 3-4 are off. There''s no battery in any slot. What does this mean?', 'neutral', '2023-12-15 15:00:00'),
(50, 'agent', 'Hi Derek! Solid red on slot 1 with blinking orange on slot 2 and no batteries inserted indicates the hub needs a firmware update. It''s a status code that was added in a recent version. Connect the hub to your computer via USB and run the SkyVision Updater tool.', 'neutral', '2023-12-15 15:05:00'),
(50, 'customer', 'I connected it and the updater found version 2.3.0 available. Currently on 1.8.0. Updating now.', 'neutral', '2023-12-15 15:10:00'),
(50, 'agent', 'Great — that''s a significant update. Version 2.3.0 improves charging efficiency and adds better battery health reporting on the built-in display. The LED codes will go back to normal after the update completes.', 'neutral', '2023-12-15 15:15:00'),
(50, 'customer', 'Update complete! LEDs are all off now (no batteries). I inserted a battery and it shows normal green charging light. Everything looks good. Thanks!', 'positive', '2023-12-15 15:25:00'),
(50, 'agent', 'Perfect! The hub was just asking for its update. You''ll notice the new battery health display now shows more detail including estimated remaining cycles. Enjoy!', 'positive', '2023-12-15 15:30:00');

-- Session 51: SkyVision Pro registration help (support)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(51, 'customer', 'I need help registering my SkyVision Pro with the FAA. The app mentions registration is required but doesn''t explain the process. Do I register through SkyVision or directly with the FAA?', 'neutral', '2023-12-20 10:00:00'),
(51, 'agent', 'Hi Liam! FAA registration is required for any drone over 250g, and the SkyVision Pro qualifies at 895g. You register directly with the FAA at faadronezone.faa.gov. It costs $5 for recreational users and $5 per drone for commercial (Part 107). Are you flying recreationally or commercially?', 'neutral', '2023-12-20 10:05:00'),
(51, 'customer', 'Recreationally for now, but I''m thinking about doing real estate photography on the side. Should I get the Part 107 license?', 'neutral', '2023-12-20 10:10:00'),
(51, 'agent', 'If you plan to earn any money from your drone footage, you legally need a Part 107 Remote Pilot Certificate. The exam costs $175 and covers airspace rules, weather, and regulations. Many people pass with 2-3 weeks of study using free online prep courses.', 'neutral', '2023-12-20 10:18:00'),
(51, 'customer', 'Good to know. I''ll start with recreational registration and study for Part 107. Thanks for the clear explanation!', 'positive', '2023-12-20 10:25:00'),
(51, 'agent', 'Great plan! After you get your FAA registration number, enter it in the SkyVision app under Settings > Registration. The app will display it on screen during flight as required. Good luck with Part 107!', 'positive', '2023-12-20 10:30:00');

-- Session 52: FlightPack Battery cycle count check (support)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(52, 'customer', 'How do I check the charge cycle count on my FlightPack batteries? I want to know if they''re getting close to end of life. I use them heavily for survey work.', 'neutral', '2023-12-26 13:00:00'),
(52, 'agent', 'Hi Zara! You can check cycle count in two ways: 1) Insert the battery in the drone and open the SkyVision app > Battery > Health > Cycle Count. 2) If you have a QuickCharge Hub, it displays cycle count on its built-in screen when a battery is inserted.', 'neutral', '2023-12-26 13:05:00'),
(52, 'customer', 'My oldest battery shows 287 cycles. The spec says 300 cycle lifespan. Should I replace it soon?', 'neutral', '2023-12-26 13:10:00'),
(52, 'agent', 'The 300 cycle rating is when the battery retains 80% of original capacity. Many batteries continue working beyond that with gradual capacity reduction. Check the health percentage — if it''s above 70%, you can keep using it safely. Below 70%, I''d recommend replacing it.', 'neutral', '2023-12-26 13:18:00'),
(52, 'customer', 'It shows 74% health. So I have some life left but should plan for a replacement. Good to know. Thanks!', 'positive', '2023-12-26 13:25:00'),
(52, 'agent', 'Exactly. At 74% you''ll notice about 25% less flight time but the battery is still safe to use. Start shopping for a replacement when it drops below 70%. We offer a 10% discount on batteries when you trade in an old one at any authorized dealer.', 'positive', '2023-12-26 13:30:00');

-- Session 53: DroneLink Controller screen brightness (support)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(53, 'customer', 'I can''t see the DroneLink Controller screen at all in bright sunlight. Is there a way to increase the brightness beyond the default max? The auto-brightness doesn''t seem to go high enough.', 'neutral', '2024-01-01 11:00:00'),
(53, 'agent', 'Hi Kenji! The DroneLink Controller has a hidden "Outdoor Mode" that boosts screen brightness by 40% beyond the normal max. Go to Controller Settings > Display > tap the brightness slider 5 times quickly. This unlocks the extended brightness range.', 'neutral', '2024-01-01 11:05:00'),
(53, 'customer', 'That''s a strange way to access it, but it works! The screen is much more visible now. Why isn''t this in the regular settings?', 'positive', '2024-01-01 11:12:00'),
(53, 'agent', 'Outdoor Mode uses more power and generates extra heat, so we don''t make it the default. It reduces battery life by about 20%. We also sell a sunshade hood accessory that fits the DroneLink Controller screen — it helps in bright conditions without the extra power drain.', 'neutral', '2024-01-01 11:18:00'),
(53, 'customer', 'I''ll use Outdoor Mode for sunny days and the regular brightness otherwise. Maybe mention this feature in the manual though — it took contacting support to find it!', 'positive', '2024-01-01 11:25:00'),
(53, 'agent', 'You make a great point — we''ll update the manual and add it to our FAQ. Thanks for the feedback, Kenji! Happy flying!', 'positive', '2024-01-01 11:30:00');

-- Session 54: SkyVision Pro noise reduction request (feedback)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(54, 'customer', 'The SkyVision Pro is an amazing drone but it''s very loud. I do wildlife photography and the noise scares animals away before I can get close. Are there plans for quieter propellers or motors?', 'neutral', '2024-01-02 14:00:00'),
(54, 'agent', 'Hi Rachel! Noise reduction is a top priority for our R&D team. We''re developing low-noise propellers with swept tips that reduce prop noise by about 40%. They should be available as an aftermarket accessory compatible with the current SkyVision Pro.', 'neutral', '2024-01-02 14:05:00'),
(54, 'customer', 'A 40% reduction would be significant! When can I get them? I have a wildlife documentary project starting in spring.', 'positive', '2024-01-02 14:10:00'),
(54, 'agent', 'We''re targeting March 2024 availability. In the meantime, try flying at higher altitudes (50-80m) — the noise drops off significantly with distance. The VisionCam Gimbal''s zoom can compensate for the extra altitude.', 'neutral', '2024-01-02 14:18:00'),
(54, 'customer', 'Higher altitude with zoom is a good workaround. I''ll pre-order the quiet props when they''re available. This could be a game-changer for wildlife and event photography.', 'positive', '2024-01-02 14:25:00'),
(54, 'agent', 'I''ll add you to the notification list for the quiet propellers. Your wildlife photography use case is exactly why we''re prioritizing this. Thank you for the feedback!', 'positive', '2024-01-02 14:30:00');

-- Session 55: FlightPack Battery longer range request (feedback)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(55, 'customer', 'The 6000mAh FlightPack gives me about 40 minutes of flight. For my survey work, I need at least 60 minutes. Are there plans for a higher capacity battery? I''d gladly accept some extra weight.', 'neutral', '2024-01-03 09:00:00'),
(55, 'agent', 'Hi David! Great question. We''re developing a FlightPack 8000mAh that targets 55-minute flight times. There''s also a FlightPack 10000mAh Pro in early testing that could push 65+ minutes, but it adds about 200g.', 'positive', '2024-01-03 09:05:00'),
(55, 'customer', 'The 10000mAh Pro sounds perfect for survey work. 200g extra weight is totally acceptable for an extra 25 minutes of flight time. When will these be available?', 'positive', '2024-01-03 09:10:00'),
(55, 'agent', 'The 8000mAh is coming Q1 2024. The 10000mAh Pro is still in testing, likely Q3 2024. Both will be compatible with existing SkyVision Pro drones and the QuickCharge Hub. I''ll put you on the early access list.', 'positive', '2024-01-03 09:18:00'),
(55, 'customer', 'Sign me up for early access on the 10000mAh Pro. This is exactly what the surveying community needs. Thanks!', 'positive', '2024-01-03 09:25:00'),
(55, 'agent', 'You''re on the list! We''d also love your feedback during the testing phase if you''re interested in being a beta tester. Your survey experience would be invaluable. Thank you, David!', 'positive', '2024-01-03 09:30:00');

-- Session 56: SkyVision Pro loud motors (complaint)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(56, 'customer', 'I''m getting complaints from my neighbors about the noise from my SkyVision Pro. The motors are louder than advertised — the spec says 65dB but I measured 78dB at 1 meter. That''s misleading.', 'negative', '2024-01-04 11:00:00'),
(56, 'agent', 'Hi Emma, I understand the noise concern. The 65dB specification is measured at 10 meters altitude, which is the standard industry measurement distance. At 1 meter, all drones will measure significantly louder.', 'neutral', '2024-01-04 11:05:00'),
(56, 'customer', 'Even at altitude, my neighbors can hear it. I fly from my backyard and they''ve complained multiple times. The marketing made it sound much quieter than it actually is.', 'negative', '2024-01-04 11:12:00'),
(56, 'agent', 'I understand your frustration. For neighborhood flying, we recommend: 1) Fly during reasonable hours (10am-5pm), 2) Take off from the farthest point from neighbors, 3) Gain altitude quickly to reduce ground-level noise. We''re also developing low-noise propellers coming in Q1 2024.', 'neutral', '2024-01-04 11:22:00'),
(56, 'customer', 'Low-noise props would help. But the spec sheet should be clearer about measurement conditions. "65dB" without context is misleading.', 'negative', '2024-01-04 11:35:00'),
(56, 'agent', 'You''re right — we should be more transparent about measurement conditions. I''m passing this feedback to our marketing team. For the low-noise propellers, I''ll add you to the notification list. Thank you for the honest feedback, Emma.', 'neutral', '2024-01-04 12:00:00');

-- Session 57: FlightPack Battery unreliable (complaint)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(57, 'customer', 'My FlightPack Battery randomly drops from 30% to 5% in seconds during flight. This has triggered emergency landings twice in locations where I couldn''t safely land. Your batteries are unreliable and dangerous.', 'negative', '2024-01-05 10:00:00'),
(57, 'agent', 'Andre, this is a serious safety concern. Sudden voltage drops are dangerous and shouldn''t happen. Can you tell me the battery''s serial number and how many charge cycles it has? Also, what temperatures are you flying in?', 'neutral', '2024-01-05 10:05:00'),
(57, 'customer', 'Serial FPB-2023-06-2198. About 180 cycles. Temperature was around 45°F both times. The app shows battery health at 82%.', 'neutral', '2024-01-05 10:12:00'),
(57, 'agent', 'At 45°F, LiPo batteries can show this behavior if they haven''t been pre-warmed. The cold causes internal resistance to spike, which can mimic a sudden voltage drop. That said, the battery should still handle 45°F. I want to pull the flight logs to investigate.', 'neutral', '2024-01-05 10:20:00'),
(57, 'customer', 'I''ll send the logs. But a $90 battery should work at 45°F without surprise emergency landings. That''s not extreme cold — it''s a normal autumn day.', 'negative', '2024-01-05 10:30:00'),
(57, 'agent', 'You''re absolutely right. I''m sending you a replacement battery immediately and flagging this unit for analysis. As a precaution, use the QuickCharge Hub''s pre-warm feature before flying in temperatures below 50°F — it brings the battery to optimal temperature before flight.', 'neutral', '2024-01-05 10:45:00'),
(57, 'customer', 'I didn''t know about the pre-warm feature. Send the replacement. But please investigate why this happened — someone could lose a drone or worse.', 'neutral', '2024-01-05 11:00:00');

-- Session 58: DroneLink Controller build quality (complaint, escalated)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(58, 'customer', 'My DroneLink Controller is falling apart. The rubber grip is peeling off, the screen has developed a dead pixel cluster, and the antenna hinge is loose — all within 10 months. For $250, I expected much better build quality.', 'negative', '2024-01-06 09:00:00'),
(58, 'agent', 'Hi Ava, I''m sorry to hear about these issues. Multiple failures on a single unit is not our quality standard. Let me review each issue and see what we can do.', 'neutral', '2024-01-06 09:05:00'),
(58, 'customer', 'I don''t want individual fixes. I want a brand new replacement controller. This unit is clearly defective. I take good care of my equipment — my 5-year-old gaming controller has no issues.', 'negative', '2024-01-06 09:12:00'),
(58, 'agent', 'I completely understand. Multiple simultaneous issues point to a manufacturing quality problem rather than normal wear. However, I need to escalate a full replacement to my supervisor for approval. Can you hold while I do that?', 'neutral', '2024-01-06 09:18:00'),
(58, 'customer', 'Fine. But I want this resolved today. I have a shoot this weekend and I need a working controller.', 'negative', '2024-01-06 09:25:00'),
(58, 'agent', 'I''ve escalated this to priority support. You''ll hear from our escalation team within 4 hours with a resolution. Given your weekend deadline, I''ve flagged this as urgent. I apologize for the quality issues, Ava.', 'neutral', '2024-01-06 09:35:00');

-- Session 59: VisionCam Gimbal marketing mismatch (complaint)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(59, 'customer', 'I bought the VisionCam Gimbal based on your ad showing 8K timelapse capability. But the camera only does 8K in photo mode, not video. The ad was extremely misleading. I feel cheated.', 'negative', '2024-01-06 15:00:00'),
(59, 'agent', 'Hi Chris, I understand your frustration. You''re correct that 8K is currently only available in still photo mode. The VisionCam Gimbal records video up to 5.1K at 50fps. Let me look into the specific advertisement you saw.', 'neutral', '2024-01-06 15:05:00'),
(59, 'customer', 'It was the YouTube ad that said "Capture the world in stunning 8K." No mention of "photos only." I specifically bought this for 8K video.', 'negative', '2024-01-06 15:12:00'),
(59, 'agent', 'I''ve found the ad and you''re right — it doesn''t clearly distinguish between photo and video resolution. I''m flagging this with our marketing compliance team. For your situation, I can offer a full refund on the gimbal, or a $100 credit toward future purchases if you''d like to keep it. The 5.1K video quality is still excellent.', 'neutral', '2024-01-06 15:22:00'),
(59, 'customer', 'I''ll keep the gimbal and take the $100 credit. But please fix that ad. It''s genuinely misleading.', 'neutral', '2024-01-06 15:35:00'),
(59, 'agent', 'I''ve applied the $100 credit to your account and reported the ad to our marketing team for correction. You''re right to call this out — our advertising should be clear and accurate. Thank you for bringing it to our attention.', 'neutral', '2024-01-06 16:00:00');

-- Session 60: QuickCharge Hub USB broke (complaint)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(60, 'customer', 'The USB-A port on my QuickCharge Hub broke off. I was plugging in a cable to update the firmware and the entire port came loose from the circuit board. The hub is only 7 months old.', 'negative', '2024-01-07 10:00:00'),
(60, 'agent', 'Hi Maya, I''m sorry about the broken USB port. That shouldn''t happen with normal use. Was there any unusual force when plugging in, or did it feel loose before it broke?', 'neutral', '2024-01-07 10:05:00'),
(60, 'customer', 'No unusual force at all. It just came loose. Looking inside, the solder joints look like they were barely connected in the first place. Poor quality soldering.', 'negative', '2024-01-07 10:12:00'),
(60, 'agent', 'That''s a manufacturing solder defect. This is fully covered under warranty. I''m sending you a replacement QuickCharge Hub. For future firmware updates on the current hub, you can actually update via WiFi through the SkyVision app — no USB needed.', 'neutral', '2024-01-07 10:20:00'),
(60, 'customer', 'Good to know about WiFi updates. Please ship the replacement quickly — I need it for charging my batteries for weekend shoots.', 'neutral', '2024-01-07 10:30:00'),
(60, 'agent', 'Express shipping is on us — you''ll have the replacement by Friday. Transfer your batteries to the new hub and recycle the old one through our electronics recycling program. Sorry again for the defect!', 'neutral', '2024-01-07 11:00:00');

-- Session 61: SkyVision Pro waypoint sharing (feedback)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(61, 'customer', 'I created an amazing waypoint mission for a vineyard aerial tour. My friend also has a SkyVision Pro and wants the same route. There''s no way to share waypoint missions! Can you add this feature?', 'neutral', '2024-01-07 14:00:00'),
(61, 'agent', 'Hi Alex! Waypoint sharing is our most requested feature right now. We''re building it into app version 4.0. You''ll be able to export missions as .skywp files and share them via email, AirDrop, or a community library.', 'positive', '2024-01-07 14:05:00'),
(61, 'customer', 'A community library would be incredible! Imagine finding pre-made waypoint missions for famous landmarks and scenic routes. Like a flight path marketplace.', 'positive', '2024-01-07 14:10:00'),
(61, 'agent', 'That''s exactly the vision! We''re calling it SkyRoutes — a community-driven library of waypoint missions. Users can upload, rate, and download missions for locations worldwide. We''re also partnering with travel photography communities to seed the library.', 'positive', '2024-01-07 14:18:00'),
(61, 'customer', 'SkyRoutes sounds amazing. I''d contribute my vineyard tours and other scenic routes from my travels. Sign me up for beta access!', 'positive', '2024-01-07 14:25:00'),
(61, 'agent', 'You''re on the beta list! SkyRoutes is planned for Q2 2024. We''d love your vineyard missions in the launch library. Thank you for the enthusiasm and great ideas, Alex!', 'positive', '2024-01-07 14:30:00');

-- Session 62: SkyVision Pro geofencing issue (troubleshooting, open)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(62, 'customer', 'My SkyVision Pro won''t take off at all. It says "Flight Restricted Zone" but I''m in my backyard in a rural area, miles from any airport. There''s no reason for a geofence here.', 'negative', '2024-01-08 09:00:00'),
(62, 'agent', 'Hi Priya! That''s unusual for a rural area. The geofence database occasionally has errors. Can you tell me your approximate location (city/town) so I can check the geofence map? Also, are you connected to the internet? The drone needs an internet connection to download the latest geofence data.', 'neutral', '2024-01-08 09:05:00'),
(62, 'customer', 'I''m in Greenfield, Vermont. Population 2,000. No airport for 30 miles. And yes, my phone is connected to cellular data.', 'neutral', '2024-01-08 09:10:00'),
(62, 'agent', 'I''m checking our geofence database... I see the issue. A temporary flight restriction (TFR) was issued for a nearby area for a presidential visit. These TFRs can cover wide areas. Check the FAA B4UFLY app to see the exact boundaries. If you''re outside the TFR, try toggling airplane mode on your phone and restarting the drone — it may be using cached geofence data.', 'neutral', '2024-01-08 09:18:00'),
(62, 'customer', 'I checked B4UFLY and there IS a TFR but it''s 15 miles away. My location is clearly outside it. The drone is being too conservative with the boundary.', 'negative', '2024-01-08 09:30:00');

-- Session 63: FlightPack Battery smaller portable version (feedback)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(63, 'customer', 'I love the FlightPack Battery performance but it''s bulky for travel. Have you considered a smaller, lighter version — maybe 3000mAh — for casual flying and travel? I''d trade flight time for portability.', 'neutral', '2024-01-08 15:00:00'),
(63, 'agent', 'Hi Marcus! A travel-friendly battery is something we''ve been discussing. The SkyVision Pro can actually fly on a lower capacity battery safely. A 3000mAh version would give roughly 20 minutes of flight time at about 40% less weight.', 'neutral', '2024-01-08 15:05:00'),
(63, 'customer', 'Twenty minutes is enough for casual vacation footage. And saving 40% weight means I could carry 3 travel batteries in the space of 2 standard ones. Perfect for backpacking trips.', 'positive', '2024-01-08 15:12:00'),
(63, 'agent', 'Great feedback! I''ve logged this as a product request. The travel use case is compelling — lighter batteries also mean staying under airline spare battery weight limits more easily. We''ll consider this for our battery lineup expansion.', 'positive', '2024-01-08 15:20:00'),
(63, 'customer', 'Exactly the airline angle too. Please make this happen! Thanks for listening.', 'positive', '2024-01-08 15:25:00'),
(63, 'agent', 'Thank you, Marcus! Your feedback goes directly to our product planning team. We''ll keep you updated on any new battery offerings. Happy travels!', 'positive', '2024-01-08 15:30:00');

-- Session 64: DroneLink Controller API access (feedback)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(64, 'customer', 'I''m a software developer and I want to build custom apps that interface with the DroneLink Controller. Do you have an SDK or API? I want to create a mapping application that overlays terrain data on the controller screen.', 'neutral', '2024-01-09 10:00:00'),
(64, 'agent', 'Hi Elena! We love hearing from developers. We currently have a limited Mobile SDK for iOS and Android that can interface with the drone through the controller. A full Controller SDK with direct screen access is in development.', 'neutral', '2024-01-09 10:05:00'),
(64, 'customer', 'A Controller SDK with screen access would be perfect. I want to overlay USGS elevation data and property boundaries in real-time during survey flights. When will it be available?', 'positive', '2024-01-09 10:10:00'),
(64, 'agent', 'The Controller SDK is planned for Q3 2024. It''ll include screen overlay APIs, custom widget support, and access to telemetry data streams. We''re looking for developer partners to beta test — would you be interested?', 'positive', '2024-01-09 10:18:00'),
(64, 'customer', 'Absolutely! Sign me up for the developer beta. I can provide feedback from a surveying/mapping perspective. This could make the SkyVision Pro the go-to platform for professional surveyors.', 'positive', '2024-01-09 10:25:00'),
(64, 'agent', 'You''re registered for the developer beta program! We''ll send you early access docs and API keys when the beta opens. Your mapping use case is exactly the kind of application we envision. Thank you, Elena!', 'positive', '2024-01-09 10:30:00');

-- Session 65: VisionCam Gimbal waterproofing (feedback)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(65, 'customer', 'I shoot a lot of content near waterfalls and the ocean. The SkyVision Pro handles moisture okay, but the VisionCam Gimbal has no water protection at all. Any plans for waterproofing?', 'neutral', '2024-01-09 14:00:00'),
(65, 'agent', 'Hi Tyler! Waterproofing the gimbal is challenging due to the moving parts and electronics, but it''s something we''re researching. Currently, we recommend a hydrophobic lens coating spray (available on our accessories page) and avoiding direct spray.', 'neutral', '2024-01-09 14:05:00'),
(65, 'customer', 'A hydrophobic coating helps the lens, but what about the motor joints and electronics? I''ve had moisture warnings after coastal flights. A proper weather-sealed gimbal would open up so many shooting possibilities.', 'neutral', '2024-01-09 14:12:00'),
(65, 'agent', 'You''re right — weather sealing the entire gimbal assembly is the real solution. Our engineering team is prototyping an IP54-rated VisionCam Gimbal that can handle rain and spray. It''s early stage but targeted for late 2024.', 'neutral', '2024-01-09 14:18:00'),
(65, 'customer', 'IP54 would be a huge selling point. Even light rain shuts down most drone cameras. I''d pay a premium for weather-sealed gear.', 'positive', '2024-01-09 14:25:00'),
(65, 'agent', 'Noted! Premium pricing for a weather-sealed version is what we''re considering. Your use case around waterfalls and coastal areas is great feedback for the product team. Thank you!', 'positive', '2024-01-09 14:30:00');

-- Session 66: SkyVision Pro flight school recommendations (support)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(66, 'customer', 'I''m a beginner with my SkyVision Pro. Are there any recommended flight schools or training programs? I want to learn properly before I crash this expensive drone.', 'neutral', '2024-01-10 10:00:00'),
(66, 'agent', 'Hi Mei Lin! Smart approach — proper training prevents costly mistakes. We have several options: 1) SkyVision Flight Academy online course (free with purchase), 2) Partner flight schools in most major cities, 3) In-app tutorial missions that teach you in simulator mode first.', 'positive', '2024-01-10 10:05:00'),
(66, 'customer', 'The in-app simulator sounds perfect for starting out. How realistic is it?', 'neutral', '2024-01-10 10:10:00'),
(66, 'agent', 'The simulator accurately models the SkyVision Pro''s flight dynamics including wind response, GPS modes, and camera controls. It uses your phone''s gyroscope for controller input. Complete the 10 tutorial missions and you''ll be confident for your first real flight.', 'positive', '2024-01-10 10:15:00'),
(66, 'customer', 'I''ll start with the simulator missions tonight. After that, where can I find a local instructor for hands-on training?', 'neutral', '2024-01-10 10:20:00'),
(66, 'agent', 'Check skyvisiondrones.com/instructors for certified instructors near you. Most offer a 2-hour "First Flight" session for $100-150. They''ll cover takeoff, landing, emergency procedures, and basic camera work. It''s the best investment for a new pilot!', 'positive', '2024-01-10 10:25:00'),
(66, 'customer', 'This is really helpful. I''ll do the simulator first and then book an instructor. Thanks!', 'positive', '2024-01-10 10:30:00');

-- Session 67: FlightPack Battery cold weather drain (troubleshooting, open)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(67, 'customer', 'I''m trying to use my SkyVision Pro in winter conditions (around 25°F) and the FlightPack Battery drains from 100% to 30% in under 10 minutes. Normal summer flights give me 40 minutes. Is the battery defective?', 'negative', '2024-01-10 15:00:00'),
(67, 'agent', 'Hi Ryan! This is actually expected behavior for LiPo batteries in cold weather. At 25°F, chemical reactions inside the battery slow down dramatically, causing much faster apparent discharge and reduced capacity. The battery isn''t defective.', 'neutral', '2024-01-10 15:05:00'),
(67, 'customer', 'So I can''t fly in winter at all? That eliminates half the year for me. Are there cold-weather batteries available?', 'negative', '2024-01-10 15:10:00'),
(67, 'agent', 'You can still fly! Here are cold weather tips: 1) Pre-warm the battery using the QuickCharge Hub''s pre-warm feature or keep it in your jacket pocket before flight. 2) Start with a battery at 85°F+ internal temp. 3) Fly conservatively — no aggressive maneuvers. 4) Land at 40% instead of the usual 20% for safety.', 'neutral', '2024-01-10 15:18:00'),
(67, 'customer', 'My QuickCharge Hub doesn''t have a pre-warm option. Is that a newer feature?', 'neutral', '2024-01-10 15:25:00');

-- Session 68: DroneLink Controller joystick drift (troubleshooting, open)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(68, 'customer', 'Both joysticks on my DroneLink Controller have developed drift. The left stick drifts up (throttle creep) and the right stick drifts slightly right. I''ve recalibrated multiple times.', 'negative', '2024-01-11 09:00:00'),
(68, 'agent', 'Hi Sofia! Drift on both sticks after calibration suggests the hall-effect sensors may be degrading. How old is the controller and how heavily do you use it?', 'neutral', '2024-01-11 09:05:00'),
(68, 'customer', 'About 14 months old. I use it almost daily for commercial work — probably 500+ hours of stick time.', 'neutral', '2024-01-11 09:10:00'),
(68, 'agent', 'At 500+ hours of commercial use, the joystick mechanisms are beyond their rated lifespan. The DroneLink Controller sticks are rated for about 400 hours. Since you''re just past warranty (12 months), let me check if we can make an exception given the heavy professional use.', 'neutral', '2024-01-11 09:18:00'),
(68, 'customer', 'I''d appreciate that. $250 for a controller that lasts 14 months with daily use isn''t great. Pro users need more durable sticks.', 'negative', '2024-01-11 09:25:00');

-- Session 69: VisionCam Gimbal horizon drift (troubleshooting, open)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(69, 'customer', 'My VisionCam Gimbal has developed a slow horizon drift during flight. The horizon starts level but gradually tilts about 5 degrees over a 10-minute flight. Auto-calibration doesn''t fix it permanently.', 'negative', '2024-01-11 14:00:00'),
(69, 'agent', 'Hi Nathan! Progressive horizon drift usually indicates a gyroscope calibration issue in the gimbal''s IMU. Have you tried the advanced calibration? Place the drone on a perfectly level surface, go to Camera > Gimbal > Advanced IMU Calibration, and let it run for 2 minutes without touching the drone.', 'neutral', '2024-01-11 14:05:00'),
(69, 'customer', 'I''ve done the advanced calibration three times on a leveled surface. It fixes it temporarily but after 5-10 minutes of flight, the drift returns. It''s always to the right.', 'negative', '2024-01-11 14:12:00'),
(69, 'agent', 'Consistent rightward drift after calibration points to a hardware issue — likely a failing gyroscope sensor in the roll axis. This needs a gimbal board replacement. Since this is a hardware fault, it should be covered under warranty. How old is your VisionCam Gimbal?', 'neutral', '2024-01-11 14:20:00'),
(69, 'customer', 'Ten months old. I use it for real estate photography and this drift ruins my shots. Can I get an expedited repair?', 'negative', '2024-01-11 14:30:00');

-- Session 70: FlightPack Battery warranty dispute (support, escalated)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(70, 'customer', 'I''m on my second warranty claim for a FlightPack Battery and now you''re telling me this one isn''t covered because it''s "user damage"? The battery just stopped working! I didn''t damage it.', 'negative', '2024-01-12 09:00:00'),
(70, 'agent', 'Hi Hannah! Let me review your case. The initial assessment noted signs of over-discharge — the battery voltage was below 2.5V per cell, which typically indicates the battery was stored depleted for an extended period.', 'neutral', '2024-01-12 09:05:00'),
(70, 'customer', 'I stored it over the holidays for 6 weeks. I didn''t know I had to babysit a battery. There''s nothing in the quick start guide about storage requirements. This is a product design issue, not user damage.', 'negative', '2024-01-12 09:12:00'),
(70, 'agent', 'You raise a valid point about the documentation. While deep discharge from extended storage technically falls outside warranty coverage, the storage requirements should be much more prominent in our documentation. Let me escalate this to see if we can make an exception.', 'neutral', '2024-01-12 09:20:00'),
(70, 'customer', 'I''ve been a loyal customer. I have the drone, extra batteries, the gimbal, the controller, the hub. I''ve spent over $2,000 with SkyVision. Denying a $90 battery warranty claim is bad business.', 'negative', '2024-01-12 09:30:00'),
(70, 'agent', 'You''re absolutely right, and I appreciate your loyalty. I''ve escalated this with a recommendation to honor the warranty given your customer history and the documentation gap. You''ll hear from our escalation team within 24 hours. I''m confident they''ll resolve this favorably.', 'neutral', '2024-01-12 09:45:00');

-- Session 71: SkyVision Pro persistent motor issue (troubleshooting, escalated)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(71, 'customer', 'This is my THIRD time contacting support about motor issues on my SkyVision Pro. I''ve had two motor replacements already and now a third motor is making grinding noises. There''s clearly a systemic problem with this drone.', 'negative', '2024-01-12 14:00:00'),
(71, 'agent', 'Hi Carlos! I''m pulling up your history... I see two previous motor replacements. I''m very sorry you''re dealing with this again. Having three motor failures is extremely unusual. Can you tell me which motor is affected this time?', 'neutral', '2024-01-12 14:05:00'),
(71, 'customer', 'Front-left this time. Previously it was rear-left and rear-right. At this rate, the fourth motor will fail in a couple months. I think there''s something wrong with the drone itself — maybe the ESCs are sending too much current and burning out the motors.', 'negative', '2024-01-12 14:12:00'),
(71, 'agent', 'Your theory about the ESCs is very plausible. Three motor failures on a single unit suggests the issue isn''t the motors themselves but something upstream. I want to escalate this to our engineering team for a full diagnostic. Would you be willing to send the entire drone in?', 'neutral', '2024-01-12 14:22:00'),
(71, 'customer', 'I can''t be without a drone for weeks. I use it for work. What''s the turnaround time?', 'negative', '2024-01-12 14:30:00'),
(71, 'agent', 'Given the repeated failures, I''m escalating to priority engineering support. I''m also requesting a loaner SkyVision Pro so you''re not without equipment during the diagnosis. You''ll hear from our escalation team today with logistics. We need to identify the root cause.', 'neutral', '2024-01-12 14:40:00');

-- Session 72: DroneLink Controller firmware update help (support, open)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(72, 'customer', 'I''m trying to update my DroneLink Controller firmware but the update keeps failing at 45%. I''ve tried 5 times on WiFi and 3 times via USB. Same result every time.', 'negative', '2024-01-13 10:00:00'),
(72, 'agent', 'Hi Aisha! Consistent failure at the same percentage usually means a corrupted download or insufficient storage. Let me help. First, how much free storage does the controller show in Settings > Storage?', 'neutral', '2024-01-13 10:05:00'),
(72, 'customer', 'It shows 128MB free out of 2GB. Is that enough?', 'neutral', '2024-01-13 10:10:00'),
(72, 'agent', 'The firmware update requires about 500MB of free space. You need to clear some data. Go to Settings > Storage > Clear Cache, and also consider deleting any stored flight logs on the controller (they''re already synced to your phone app). That should free up enough space.', 'neutral', '2024-01-13 10:18:00'),
(72, 'customer', 'Cleared the cache and flight logs. Now showing 1.2GB free. Attempting the update again...', 'neutral', '2024-01-13 10:25:00');

-- Session 73: SkyVision Pro value pack / social features request (feedback, escalated)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(73, 'customer', 'I love SkyVision products but the ecosystem is getting expensive. The drone is $1,200, gimbal $300, controller $250, batteries $90 each, hub $120. That''s over $2,000. Do you offer bundle pricing or a loyalty program?', 'neutral', '2024-01-13 15:00:00'),
(73, 'agent', 'Hi Jake! I understand the total cost adds up. We do offer an Essentials Bundle (drone + 2 batteries + controller) at 15% off retail, and a Professional Bundle (everything you listed) at 20% off. These are available on our website.', 'neutral', '2024-01-13 15:05:00'),
(73, 'customer', 'I already bought everything individually at full price. Can I retroactively get the bundle discount? I spent $2,140 and the Pro Bundle is $1,712. That''s a $428 difference. I would have bought the bundle if I''d known.', 'negative', '2024-01-13 15:12:00'),
(73, 'agent', 'I understand your frustration. Unfortunately, retroactive bundle pricing isn''t standard policy. However, let me escalate this to see what we can do. Your total spend with us should be recognized. I also want to share your feedback about making bundle options more visible during individual purchases.', 'neutral', '2024-01-13 15:22:00'),
(73, 'customer', 'Please do. It feels like the bundle pricing is deliberately hidden to get people to buy at full price first. Also, where''s the loyalty program? Other drone companies offer points, discounts, and perks for repeat customers.', 'negative', '2024-01-13 15:30:00'),
(73, 'agent', 'A loyalty program is actually in development — SkyVision Rewards, launching Q2 2024. Points for purchases, early access to new products, and discounts. I''ve escalated your retroactive pricing request with a recommendation to honor it. You''ll hear back within 48 hours.', 'neutral', '2024-01-13 15:40:00');

-- Session 74: SkyVision Pro accessory compatibility (support, open)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(74, 'customer', 'I found a third-party thermal camera that I want to mount on my SkyVision Pro for roof inspections. Is it compatible? The camera weighs 120g and uses a standard gimbal mount.', 'neutral', '2024-01-14 10:00:00'),
(74, 'agent', 'Hi Olivia! The SkyVision Pro can carry up to 200g of additional payload, so the weight is fine. However, third-party accessories aren''t tested with our gimbal mount. What''s the brand and model of the thermal camera?', 'neutral', '2024-01-14 10:05:00'),
(74, 'customer', 'It''s a FLIR Lepton 3.5 on a lightweight mount adapter. I''ve seen other drone users mount it successfully but I want to make sure it won''t void my warranty or affect flight stability.', 'neutral', '2024-01-14 10:12:00'),
(74, 'agent', 'Using third-party accessories won''t void your SkyVision Pro warranty. However, any damage caused by the accessory (e.g., if it falls off mid-flight) wouldn''t be covered. For flight stability, the 120g payload will reduce flight time by about 5 minutes and may require recalibrating the IMU after mounting.', 'neutral', '2024-01-14 10:20:00'),
(74, 'customer', 'Good to know. I''m actually more interested in whether SkyVision is planning an official thermal camera accessory? A purpose-built one would be much better than DIY mounting.', 'neutral', '2024-01-14 10:30:00');

-- Session 75: FlightPack Battery mapping/surveying use case (feedback, open)
INSERT INTO messages (session_id, sender, content, sentiment, created_at) VALUES
(75, 'customer', 'I use my SkyVision Pro for land surveying and mapping. The battery life is decent but the real issue is that there''s no photogrammetry software integration. I have to manually transfer photos and geotag them. Can SkyVision add mapping features?', 'neutral', '2024-01-14 14:00:00'),
(75, 'agent', 'Hi Derek! Surveying and mapping is a growing use case for us. We''re developing SkyVision Maps — an integrated mapping solution with automated flight paths, automatic geotagging with centimeter-level GPS accuracy, and direct export to common GIS formats.', 'neutral', '2024-01-14 14:05:00'),
(75, 'customer', 'Centimeter-level accuracy would require RTK GPS. Does the SkyVision Pro support RTK, or would that be a hardware upgrade?', 'neutral', '2024-01-14 14:10:00'),
(75, 'agent', 'Good observation! RTK requires additional hardware. We''re developing an RTK module that attaches to the SkyVision Pro''s accessory port. Combined with a base station, it will deliver 2cm horizontal accuracy. The SkyVision Maps software will handle the RTK corrections automatically.', 'neutral', '2024-01-14 14:18:00'),
(75, 'customer', 'That would make the SkyVision Pro competitive with dedicated survey drones costing 3-4x more. When is the RTK module expected?', 'positive', '2024-01-14 14:25:00');


-- Create indexes for better query performance
CREATE INDEX idx_chat_sessions_category ON chat_sessions(category);
CREATE INDEX idx_chat_sessions_status ON chat_sessions(status);
CREATE INDEX idx_chat_sessions_created_at ON chat_sessions(created_at);
CREATE INDEX idx_chat_sessions_product_id ON chat_sessions(product_id);
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
