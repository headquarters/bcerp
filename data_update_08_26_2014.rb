require 'rubygems'
require 'sqlite3'

db = SQLite3::Database.new 'bcerp.db'

higher_risk_level = 1
lower_risk_level = 2
no_risk_level = 3

#db.results_as_hash = true

### Age
db.execute("
  UPDATE risk_messages
  SET message = 'Older women are at higher risk for breast cancer, especially after menopause.',
      long_message = 'Older women are at higher risk for breast cancer, especially after menopause. Risk gradually increases as women get older. Breast cancer is most frequently diagnosed among women age 55-64 with more than 2/3 of women diagnosed at 55 years or older. Discuss screening and risk reduction steps with your physician.'
  WHERE group_id = 1 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Younger women are at lower risk of breast cancer, but women AT ANY AGE can get the disease.',
      long_message = 'Younger women are at lower risk of breast cancer, but women AT ANY AGE can get the disease. Approximately 11% of women younger than 45 years old are diagnosed with breast cancer each year. The Centers for Disease Control and Prevention recognizes breast cancer for young women as a very overwhelming challenge, making it important for young women to discuss their breast health with their physicians. Talk with your physician to learn steps you can take to reduce your risk at any age.'
  WHERE group_id = 1 AND risk_level_id = #{lower_risk_level}
")

### Race/Ethnicity
db.execute("
  UPDATE risk_messages
  SET message = 'Compared to white women of similar age, African-American women under 50 are more commonly diagnosed with basal-like breast cancer (also sometimes called triple negative breast cancer), a fast-growing cancer. Keep reading for information on when to start breast cancer screening, other steps to reduce risk, and how to discuss your risk with your doctor.',
      long_message = 'Compared to white women of similar age, African-American women under 50 are more commonly diagnosed with basal-like breast cancer (also sometimes called triple negative breast cancer), a fast-growing cancer. Keep reading for information on when to start breast cancer screening, other steps to reduce risk, and how to discuss your risk with your doctor. The death rate is higher among African American women in the US. Basal-like breast cancer is a fast-growing subtype of breast cancer.  Most basal-like breast cancers are also triple negative breast cancer subtypes, meaning that these cancers make low levels of three proteins that are usually targeted in breast cancer treatment.  Fewer treatment options are available for these cancers, so studies are needed to find better treatments for these cancers.'
  WHERE group_id = 2 AND risk_level_id = #{higher_risk_level}
")

### Children
db.execute("
  UPDATE risk_messages
  SET message = 'Having no children or having a first child after 35 increases breast cancer risk. Reproductive behavior is often tied to estrogen exposure, and most known risks for breast cancer are associated with lifetime exposure to estrogen.',
      long_message = 'Having no children or having a first child after 35 increases breast cancer risk. Reproductive behavior is often tied to estrogen exposure, and most known risks for breast cancer are associated with lifetime exposure to estrogen. Estrogen is a naturally occurring hormone important for sexual development and childbearing. A woman''s exposure to estrogen varies over her lifetime. Estrogen exposure may change the state or number of cells that could become cancerous.'
  WHERE group_id = 3 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Having children before age 35 decreases breast cancer risk. Keep reading and talk with your doctor about steps you can take to reduce your risk.',
      long_message = 'Having children before age 35 decreases breast cancer risk. Keep reading and talk with your doctor about steps you can take to reduce your risk. Reproductive behavior is often tied to estrogen exposure, and most known risks for breast cancer are associated with lifetime exposure to estrogen. Estrogen is a naturally occurring hormone important for sexual development and childbearing. A woman''s exposure to estrogen varies over her lifetime. Estrogen exposure may change the state or number of cells that could become cancerous. Breast cancer risk goes down for women with more children, but this may depend upon the type of breast cancer'
  WHERE group_id = 3 AND risk_level_id = #{lower_risk_level}
")

### Breastfeeding
db.execute("
  UPDATE risk_messages
  SET message = 'Having no children or breastfeeding for less than 12 months (across all children) may have hormonal or other effects on women''s breast tissue.',
      long_message = 'Having no children or breastfeeding for less than 12 months (across all children) may have hormonal or other effects on women''s breast tissue. Women who breastfeed have lower breast cancer risk than women who have children and do not breastfeed.  In addition to health benefits for mom, breastfeeding provides biological and psychological benefits to babies. '
  WHERE group_id = 4 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Good! Women who breastfeed have lower breast cancer risk than women who have children and do not breastfeed.',
      long_message = 'Good! Women who breastfeed have lower breast cancer risk than women who have children and do not breastfeed. In addition to health benefits for mom, breastfeeding provides biological and psychological benefits to babies. Having no children or breastfeeding for less than 12 months (across all children) may have hormonal or other effects on women''s breast tissue. '
  WHERE group_id = 4 AND risk_level_id = #{lower_risk_level}
")

### Relatives
db.execute("
  UPDATE risk_messages
  SET message = 'Women have higher breast cancer risk if first degree relatives (mom, dad, sister, brother, son, daughter) have a history of breast cancer.',
      long_message = 'Women have higher breast cancer risk if first degree relatives (mom, dad, sister, brother, son, daughter) have a history of breast cancer. It is also important whether your relatives had breast cancer young (before age 50) and whether your relatives had breast cancer in both breasts. Your family history of ovarian cancer is also relevant to your risk of breast cancer.'
  WHERE group_id = 5 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Having no first degree relatives with a history of breast cancer does lower your risk, but does not eliminate it.',
      long_message = 'Having no first degree relatives with a history of breast cancer does lower your risk, but does not eliminate it. It is also important whether your relatives had breast cancer young (before age 50) and whether your relatives had breast cancer in both breasts. Your family history of ovarian cancer is also relevant to your risk of breast cancer.'
  WHERE group_id = 5 AND risk_level_id = #{lower_risk_level}
")

### BMI
# BMI is group_id 18, while height/weight are group_id 6 together
db.execute("
  UPDATE risk_messages
  SET message = 'Having a Body Mass Index (BMI) of 25 or higher increases your risk of breast cancer. Keep reading to learn about changes you can make to your diet and exercise routines to maintain a healthy weight and lower your risk.',
      long_message = 'Having a Body Mass Index (BMI) of 25 or higher increases your risk of breast cancer. Keep reading to learn about changes you can make to your diet and exercise routines to maintain a healthy weight and lower your risk. Women who maintain a normal body weight, with a BMI between 18.5 and 24, are at lower risk of breast cancer. Eating a well-balanced, healthy diet, with at least five servings of fruit and vegetables daily and moderate to vigorous exercise at least 30 minutes most days will contribute to weight loss or maintaining a normal weight, improved health and reduced risk of breast cancer.'
  WHERE group_id = 18 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'By maintaining your BMI between 18.5 and 24, you''re reducing your risk of postmenopausal breast cancer. Keep reading for more ideas on steps in maintaining a healthy lifestyle and reducing breast cancer risk.',
      long_message = 'By maintaining your BMI between 18.5 and 24, you''re reducing your risk of postmenopausal breast cancer. Keep reading for more ideas on steps in maintaining a healthy lifestyle and reducing breast cancer risk. Eating a well-balanced, healthy diet, with at least five servings of fruit and vegetables daily and moderate to vigorous exercise at least 30 minutes most days will contribute to weight loss or maintaining a normal weight, improved health and reduced risk of breast cancer.'
  WHERE group_id = 18 AND risk_level_id = #{lower_risk_level}
")

### Diet habits
db.execute("
  UPDATE risk_messages
  SET message = 'Eating a diet with at least 5 servings of fruits and vegetables each day has been shown to be protective against developing breast cancer. Eat those fruits and veggies!',
      long_message = 'Eating a diet with at least 5 servings of fruits and vegetables each day has been shown to be protective against developing breast cancer. Eat those fruits and veggies! The 2010 US Dietary Guidelines recommend controlling the amount of calories you take in each day and increasing your nutrient-dense foods and drinks, such as whole grains, fruits, vegetables, low fat dairy products and lean meats.'
  WHERE group_id = 7 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Wow! Your dietary habits are on target! Eating a diet with at least 5 servings of fruits and vegetables each day has been shown to be protective against developing breast cancer. Keep up the good work!',
      long_message = 'Wow! Your dietary habits are on target! Eating a diet with at least 5 servings of fruits and vegetables each day has been shown to be protective against developing breast cancer. Keep up the good work! The 2010 US Dietary Guidelines recommend controlling the amount of calories you take in each day and increasing your nutrient-dense foods and drinks, such as whole grains, fruits, vegetables, low fat dairy products and lean meats.'
  WHERE group_id = 7 AND risk_level_id = #{lower_risk_level}
")

### Canned vs. fresh/frozen
db.execute("
  UPDATE risk_messages
  SET message = 'Fresh and frozen foods are healthier alternatives to canned foods.',
      long_message = 'Fresh and frozen foods are healthier alternatives to canned foods. Bisphenol A (BPA) is a chemical in plastic containers and in the lining of some canned goods. Research supported by the National Institutes of Health is ongoing to explore whether these chemicals influence the development of girls'' bodies and their risk of breast cancer. So serve your entire family meals made from frozen or fresh foods.'
  WHERE group_id = 8 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Good! Fresh and frozen foods are healthier alternatives to canned foods.',
      long_message = 'Good! Fresh and frozen foods are healthier alternatives to canned foods. Bisphenol A (BPA) is a chemical in plastic containers and in the lining of some canned goods. Research supported by the National Institutes of Health is ongoing to explore whether these chemicals influence the development of girls'' bodies and their risk of breast cancer. So keep serving the entire family meals made from frozen or fresh foods.'
  WHERE group_id = 8 AND risk_level_id = #{lower_risk_level}
")

### Charred meat
db.execute("
  UPDATE risk_messages
  SET message = 'Eating char grilled food exposes you to dangerous chemicals called PAHs (polycyclic aromatic hydrocarbons) that have been linked to increased risk of breast cancer. Avoid eating charred meat.',
      long_message = 'Eating char grilled food exposes you to dangerous chemicals called PAHs (polycyclic aromatic hydrocarbons) that have been linked to increased risk of breast cancer. Avoid eating charred meat. PAHs are formed when the fat from meats are grilled at high temperatures over open flames. Increases in cooking temperature, the amount of fat in the meat, and the time that the meat is cooked increases the concentration of these chemicals. To reduce exposure to PAHs, lower the cooking temperature, grill leaner meat, avoid eating charred parts of the meat, and use a thermometer to know when the meat is done.'
  WHERE group_id = 9 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Great! Eating char grilled food exposes you to chemicals that have been linked to increased risk of breast cancer, so keep avoiding them when possible.',
      long_message = 'Great! Eating char grilled food exposes you to chemicals that have been linked to increased risk of breast cancer, so keep avoiding them when possible. PAHs are formed when the fat from meats are grilled at high temperatures over open flames. Increases in cooking temperature, the amount of fat in the meat, and the time that the meat is cooked increases the concentration of these chemicals. To reduce exposure to PAHs, lower the cooking temperature, grill leaner meat, avoid eating charred parts of the meat, and use a thermometer to know when the meat is done.'
  WHERE group_id = 9 AND risk_level_id = #{lower_risk_level}
")

### Alcohol
db.execute("
  UPDATE risk_messages
  SET message = 'Having one or more servings of alcoholic drinks per day increases risk of breast cancer. For women who drink more than one serving per day, their risk is 1.5 times higher than for nondrinkers.',
      long_message = 'Having one or more servings of alcoholic drinks per day increases risk of breast cancer. For women who drink more than one serving per day, their risk is 1.5 times higher than for nondrinkers. Follow the resources below to learn about the appropriate serving sizes for various types of alcoholic drinks.'
  WHERE group_id = 10 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Alcohol consumption may have some health benefits or reduce risk of some diseases, but not true with breast cancer. Having one or more servings of alcoholic drinks per day increases women''s risk of breast cancer.',
      long_message = 'Alcohol consumption may have some health benefits or reduce risk of some diseases, but not true with breast cancer. Having one or more servings of alcoholic drinks per day increases women''s risk of breast cancer. Follow the resources below to learn about the appropriate serving sizes for various types of alcoholic drinks.'
  WHERE group_id = 10 AND risk_level_id = #{lower_risk_level}
")

### Exercise
db.execute("
  UPDATE risk_messages
  SET message = 'Regardless of a woman''s height and weight, regular exercise for 30 minutes or more, most days of the week, has been shown to reduce a woman''s risk of breast cancer and results in numerous other health benefits. No more couch potato!',
      long_message = 'Regardless of a woman''s height and weight, regular exercise for 30 minutes or more, most days of the week, has been shown to reduce a woman''s risk of breast cancer and results in numerous other health benefits. No more couch potato! Recent studies show that women reduce their risk by as much as 30% with regular exercise, with better results shown for women with increased exercise times and intensity. However, studies also show that women experience lower breast cancer risk and other health benefits, regardless of intensity. Use these resources for ideas to increase your physical activity.'
  WHERE group_id = 11 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Wow! Good job on the fitness! By exercising more than 30 minutes most days of the week, you''re reducing your risk of breast cancer and getting so many other health benefits.',
      long_message = 'Wow! Good job on the fitness! By exercising more than 30 minutes most days of the week, you''re reducing your risk of breast cancer and getting so many other health benefits. Recent studies show that women reduce their risk by as much as 30% with regular exercise, with better results shown for women with increased exercise times and intensity. However, studies also show that women experience lower breast cancer risk and other health benefits, regardless of intensity. Use these resources for even more ideas to keep your physical activity on track.'
  WHERE group_id = 11 AND risk_level_id = #{lower_risk_level}
")

### Fragrances
db.execute("
  UPDATE risk_messages
  SET message = 'Phthalates (pronounced tha-lates) are chemicals found in some personal care products like fragrances, nail polish and hair care products. When possible, use fragrance-free products.',
      long_message = 'Phthalates (pronounced tha-lates) are chemicals found in some personal care products like fragrances, nail polish and hair care products. When possible, use fragrance-free products. Research supported by the National Institutes of Health is ongoing to explore whether these chemicals influence the development of girls'' bodies and their risk of breast cancer. Use the following resources for ideas to reduce exposure to these chemicals.'
  WHERE group_id = 12 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Great! Keep using fragrance-free products when possible.',
      long_message = 'Great! Keep using fragrance-free products when possible. Phthalates (pronounced tha-lates) are chemicals found in some personal care products like fragrances, nail polish and hair care products. Research supported by the National Institutes of Health is ongoing to explore whether these chemicals influence the development of girls'' bodies and their risk of breast cancer. Use the following resources for ideas on other ways to reduce exposure to these chemicals.'
  WHERE group_id = 12 AND risk_level_id = #{lower_risk_level}
")

### Plastics vs. glass
db.execute("
  UPDATE risk_messages
  SET message = 'Bisphenol A (BPA) and phthalates (pronounced tha-lates) are chemicals in plastic containers and some food packaging. Researchers are investigating their potential links to breast cancer risk. When possible, microwave your food in glass dishes, reduce the use of canned goods and avoid plastic containers with recycle codes 3, 6 and 7.',
      long_message = 'Bisphenol A (BPA) and phthalates (pronounced tha-lates) are chemicals in plastic containers and some food packaging. Researchers are investigating their potential links to breast cancer risk. When possible, microwave your food in glass dishes, reduce the use of canned goods and avoid plastic containers with recycle codes 3, 6 and 7. Follow these resources for additional ideas for avoiding these chemicals.'
  WHERE group_id = 13 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Good! Keep using glass containers for food whenever you can.',
      long_message = 'Good! Keep using glass containers for food whenever you can. Bisphenol A (BPA) and phthalates (pronounced tha-lates) are chemicals in plastic containers and some food packaging. Researchers are investigating their potential links to breast cancer risk. In addition to microwaving your food in glass dishes, you should also reduce the use of canned goods and avoid plastic containers with recycle codes 3, 6 and 7. '
  WHERE group_id = 13 AND risk_level_id = #{lower_risk_level}
")

### Hormones
db.execute("
  UPDATE risk_messages
  SET message = 'Oral contraceptives and menopausal hormone therapy (MHT) increase a woman''s lifetime exposure to estrogen, increasing her risk of breast cancer. Avoid prolonged use of menopausal HRT, unless recommended by your doctor.',
      long_message = 'Oral contraceptives and menopausal hormone therapy (MHT) increase a woman''s lifetime exposure to estrogen, increasing her risk of breast cancer. Avoid prolonged use of menopausal HRT, unless recommended by your doctor. MHT, which is typically taken to relieve women of symptoms associated with menopause, has also been found to increase a woman''s risk of heart disease and other serious illnesses. If used, MHT should be used for a brief amount of time. The breast cancer risk associated with oral contraceptives should also be weighed against other risks and benefits with your doctor.'
  WHERE group_id = 14 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Great! Oral contraceptives and menopausal hormone therapy (MHT) increase a woman''s lifetime exposure to estrogen, so avoid prolonged exposure when possible.',
      long_message = 'Great! Oral contraceptives and menopausal hormone therapy (MHT) increase a woman''s lifetime exposure to estrogen, so avoid prolonged exposure when possible. MHT, which is typically taken to relieve women of symptoms associated with menopause, has also been found to increase a woman''s risk of heart disease and other serious illnesses. If used, MHT should be used for a brief amount of time. The breast cancer risk associated with oral contraceptives should also be weighed against other risks and benefits with your doctor.'
  WHERE group_id = 14 AND risk_level_id = #{lower_risk_level}
")

### Knowing the feel
db.execute("
  UPDATE risk_messages
  SET message = 'Know the normal look and feel of your breasts so that it is easier to spot possible abnormalities.',
      long_message = 'Know the normal look and feel of your breasts so that it is easier to spot possible abnormalities. Possible changes can occur in a woman''s breasts, and women should ask their doctors about any noticed changes. Some specific changes that can occur include: a breast or underarm lump or firmness, an inverted or tender nipple, nipple discharge, or scaly, red or swollen skin on the breast, nipple or areola.'
  WHERE group_id = 15 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Excellent! Knowing the normal look and feel of your breasts makes it easier to spot possible abnormalities.',
      long_message = 'Excellent! Knowing the normal look and feel of your breasts makes it easier to spot possible abnormalities. Women should be aware of possible changes in their breasts, and they should ask their doctors about any noticed changes. Some specific changes that can occur include: a breast or underarm lump or firmness, an inverted or tender nipple, nipple discharge, or scaly, red or swollen skin on the breast, nipple or areola.'
  WHERE group_id = 15 AND risk_level_id = #{lower_risk_level}
")

### Talk to your physician
db.execute("
  UPDATE risk_messages
  SET message = 'With your physician, discuss your family history, annual exams and the age to start mammograms.',
      long_message = 'With your physician, discuss your family history, annual exams and the age to start mammograms. Talking with your physician about getting annual exams and the age to start getting mammograms is a good way to be proactive in addressing your breast health and breast cancer.'
  WHERE group_id = 16 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Fantastic! Be sure to discuss your family history, annual exams and the age to start mammograms.',
      long_message = 'Fantastic! Be sure to discuss your family history, annual exams and the age to start mammograms. Talking with your physician about getting annual exams and the age to start getting mammograms is a good way to be proactive in addressing your breast health and breast cancer. Encourage your friends and family to take steps to protect their health too!'
  WHERE group_id = 16 AND risk_level_id = #{lower_risk_level}
")

### Getting an exam
db.execute("
  UPDATE risk_messages
  SET message = 'Annual breast exams by a physician and mammograms help detect breast cancer early, giving women a better chance for survival. US Preventive Services Task Force recommends that women ages 50-74 get mammograms every two years.',
      long_message = 'Annual breast exams by a physician and mammograms help detect breast cancer early, giving women a better chance for survival. US Preventive Services Task Force recommends that women ages 50-74 get mammograms every two years. However, women of all ages should be aware of the feel and look of their breasts and their family history. To be proactive in addressing your breast health and breast cancer, talk with your physician about getting annual exams and the age to start getting mammograms.'
  WHERE group_id = 17 AND risk_level_id = #{higher_risk_level}
")

db.execute("
  UPDATE risk_messages
  SET message = 'Great! Annual breast exams by a physician and mammograms help detect breast cancer early, giving women a better chance for survival.',
      long_message = 'Great! Annual breast exams by a physician and mammograms help detect breast cancer early, giving women a better chance for survival. Use the following resources for information on breast cancer resources in your area, and encourage your family and friends to protect their health too!'
  WHERE group_id = 17 AND risk_level_id = #{lower_risk_level}
")


puts "Done."
