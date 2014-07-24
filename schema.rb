select = InputType.create(:input_type_name => "select")
radio = InputType.create(:input_type_name => "radio")

health_history_category = Category.create(:category_name => "Health History", :category_identifier => "health-history")
diet_category = Category.create(:category_name => "Diet", :category_identifier => "diet")
exercise_category = Category.create(:category_name => "Exercise", :category_identifier => "exercise")
environment_category = Category.create(:category_name => "Environment", :category_identifier => "environment")
screening_category = Category.create(:category_name => "Screening", :category_identifier => "screening")

higher_risk_level = RiskLevel.create(:risk_level_name => "Higher Risk", :risk_level_identifier => "higher-risk")
lower_risk_level = RiskLevel.create(:risk_level_name => "Lower Risk", :risk_level_identifier => "lower-risk")
no_risk_level = RiskLevel.create(:risk_level_name => "No Risk", :risk_level_identifier => "no-risk")

### Age
group_id = 1
higher_risk_message = RiskMessage.create(:message => "Older women are at higher risk for breast cancer, especially after menopause. Discuss screening and risk reduction steps with your physician.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Older women are at higher risk for breast cancer, but women at any age can get the disease. Talk with your physician to learn steps you can take to reduce your risk AT ANY AGE.", :group_id => group_id, :risk_level => lower_risk_level)

age_question = Question.create(:question_name => "How old are you?", :group_id => group_id, :input_type => select, :category => health_history_category)

age_option_choice = OptionChoice.create(:option_choice_name => "Younger than 20")

QuestionOption.create(:question => age_question, :option_choice => age_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

age = 20

while age < 70
  age_range = "#{age}-#{age + 4}"
  
  age_option_choice = OptionChoice.create(:option_choice_name => age_range)
  
  if age < 45
    QuestionOption.create(:question => age_question, :option_choice => age_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)
  else
    QuestionOption.create(:question => age_question, :option_choice => age_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)
  end
  
  age = age + 5
end

age_option_choice = OptionChoice.create(:option_choice_name => "70+")

QuestionOption.create(:question => age_question, :option_choice => age_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

### Race/Ethnicity
group_id += 1
higher_risk_message = RiskMessage.create(:message => "African-American women under 50 are more commonly diagnosed with basal-like breast cancer (also known as triple negative breast cancer), a fast-growing cancer. Keep reading for information on when to start breast cancer screening and other steps to reduce risk, and discuss your risk with your doctor.", :group_id => group_id, :risk_level => higher_risk_level)

race_question = Question.create(:question_name => "With which race/ethnicity do you identify?", :group_id => group_id, :input_type => radio, :category => health_history_category)

race_option_choice1 = OptionChoice.create(:option_choice_name => "Black/African American")
QuestionOption.create(:question => race_question, :option_choice => race_option_choice1, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

race_option_choice2 = OptionChoice.create(:option_choice_name => "White")
QuestionOption.create(:question => race_question, :option_choice => race_option_choice2, :risk_level => no_risk_level)

race_option_choice3 = OptionChoice.create(:option_choice_name => "Hispanic/Latin American")
QuestionOption.create(:question => race_question, :option_choice => race_option_choice3, :risk_level => no_risk_level)

race_option_choice4 = OptionChoice.create(:option_choice_name => "American/Pacific Islander")
QuestionOption.create(:question => race_question, :option_choice => race_option_choice4, :risk_level => no_risk_level)

race_option_choice5 = OptionChoice.create(:option_choice_name => "Asian")
QuestionOption.create(:question => race_question, :option_choice => race_option_choice5, :risk_level => no_risk_level)

race_option_choice6 = OptionChoice.create(:option_choice_name => "Other")
QuestionOption.create(:question => race_question, :option_choice => race_option_choice6, :risk_level => no_risk_level)


### Children
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Having no children or having a first child after 35 increases breast cancer risk, because your lifetime exposure to estrogen is higher with no or later pregnancies. Most risks for breast cancer are associated with lifetime exposure to estrogen.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Having children before age 35 decreases breast cancer risk. Keep reading and talk with your doctor about steps you can take to reduce your risk.", :group_id => group_id, :risk_level => lower_risk_level)

children_question = Question.create(:question_name => "How old were you when your first child was born?", :group_id => group_id, :input_type => radio, :category => health_history_category)

no_children_option_choice = OptionChoice.create(:option_choice_name => "I have no children")
QuestionOption.create(:question => children_question, :option_choice => no_children_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

children_option_choice = OptionChoice.create(:option_choice_name => "Younger than 35")
QuestionOption.create(:question => children_question, :option_choice => children_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

children_option_choice = OptionChoice.create(:option_choice_name => "35 or older")
QuestionOption.create(:question => children_question, :option_choice => children_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

### Breastfeeding
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Breastfeeding for less than 12 months across all children increases your exposure to estrogen. Most risks for breast cancer are associated with lifetime exposure to estrogen.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Good! Breastfeeding for more than 12 months across all children decreases your risk, and it protects your child's health, too.", :group_id => group_id, :risk_level => lower_risk_level)

breastfeeding_question = Question.create(:question_name => "How many months (total) did you breast feed across all your children?", :group_id => group_id, :input_type => radio, :category => health_history_category)

QuestionOption.create(:question => breastfeeding_question, :option_choice => no_children_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

breastfeeding_option_choice = OptionChoice.create(:option_choice_name => "0-11 months")
QuestionOption.create(:question => breastfeeding_question, :option_choice => breastfeeding_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

breastfeeding_option_choice = OptionChoice.create(:option_choice_name => "12+ months")
QuestionOption.create(:question => breastfeeding_question, :option_choice => breastfeeding_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

### Relatives
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Women have higher breast cancer risk if first degree relatives (mom, dad, sister, brother, son, daughter) have a history of breast cancer.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Having no first degree relatives with a history of breast cancer does lower your risk, but does not eliminate it.", :group_id => group_id, :risk_level => lower_risk_level)

relatives_question = Question.create(:question_name => "Have any of your first-degree relatives (mother, sister, daughter, father, brother, or son) ever had breast or ovarian cancer?", :group_id => 5, :input_type => radio, :category => health_history_category)

yes_option_choice = OptionChoice.create(:option_choice_name => "Yes")
QuestionOption.create(:question => relatives_question, :option_choice => yes_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

no_option_choice = OptionChoice.create(:option_choice_name => "No")
QuestionOption.create(:question => relatives_question, :option_choice => no_option_choice, :risk_level => lower_risk_level, :risk_message => higher_risk_message)

### Height
# No inherent risk level associated with height. See BMI.
group_id += 1
height_question = Question.create(:question_name => "How tall are you (in feet and inches)?", :group_id => group_id, :input_type => select, :category => health_history_category)

height_option_choice = OptionChoice.create(:option_choice_name => "Less than 4'", :option_choice_value => 47.0)
QuestionOption.create(:question => height_question, :option_choice => height_option_choice, :risk_level => no_risk_level)

for feet in 4..6
  for inches in 0..11
    if(inches == 0)
      name = "#{feet}'"
    else
      name = "#{feet}' #{inches}\""
    end
    total_inches = (feet * 12) + inches
    height_option_choice = OptionChoice.create(:option_choice_name => name, :option_choice_value => total_inches)
    QuestionOption.create(:question => height_question, :option_choice => height_option_choice, :risk_level => no_risk_level)
  end  
end

height_option_choice = OptionChoice.create(:option_choice_name => "More than 6'", :option_choice_value => 71.0)

QuestionOption.create(:question => height_question, :option_choice => height_option_choice, :risk_level => no_risk_level)

### Weight
# No inherent risk level associated with weight. See BMI.

weight_question = Question.create(:question_name => "How much do you weigh (in pounds)?", :group_id => group_id, :input_type => select, :category => health_history_category)

weight_option_choice = OptionChoice.create(:option_choice_name => "Less than 90", :option_choice_value => 89.0)
QuestionOption.create(:question => weight_question, :option_choice => weight_option_choice, :risk_level => no_risk_level)

for weight in 90..299
  # use same weight as String presented to user (name) and Integer used for calculation (value)
  weight_option_choice = OptionChoice.create(:option_choice_name => weight, :option_choice_value => weight)
  QuestionOption.create(:question => weight_question, :option_choice => weight_option_choice, :risk_level => no_risk_level)
end

weight_option_choice = OptionChoice.create(:option_choice_name => "300+", :option_choice_value => 301.0)
QuestionOption.create(:question => weight_question, :option_choice => weight_option_choice, :risk_level => no_risk_level)


### Diet Habits
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Eating a diet with at least 5 servings of fruits and vegetables each day has been shown to be protective against developing breast cancer. Eat those fruits and veggies!", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Wow! Your dietary habits are on target! Eating a diet with at least 5 servings of fruits and vegetables each day has been shown to be protective against developing breast cancer. Keep up the good work!", :group_id => group_id, :risk_level => lower_risk_level)

diet_habits_question = Question.create(:question_name => "How would you describe your dietary habits?", :group_id => group_id, :input_type => radio, :category => diet_category)

diet_option_choice = OptionChoice.create(:option_choice_name => "You eat a well-balanced, low-fat diet.")
QuestionOption.create(:question => diet_habits_question, :option_choice => diet_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

diet_option_choice = OptionChoice.create(:option_choice_name => "You eat some high-fat and junk food a few times a week.")
QuestionOption.create(:question => diet_habits_question, :option_choice => diet_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

diet_option_choice = OptionChoice.create(:option_choice_name => "You regularly eat high-fat and junk food.")
QuestionOption.create(:question => diet_habits_question, :option_choice => diet_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

### Fresh/frozen foods
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Fresh and frozen foods are healthier alternatives to canned foods.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Good! Fresh and frozen foods are healthier alternatives to canned foods.", :group_id => group_id, :risk_level => lower_risk_level)

fresh_or_frozen_question = Question.create(:question_name => "Do you most often eat fresh/frozen foods or canned?", :group_id => group_id, :input_type => radio, :category => diet_category)

ff_option_choice = OptionChoice.create(:option_choice_name => "Fresh/frozen foods")
QuestionOption.create(:question => fresh_or_frozen_question, :option_choice => ff_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

ff_option_choice = OptionChoice.create(:option_choice_name => "Canned foods")
QuestionOption.create(:question => fresh_or_frozen_question, :option_choice => ff_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

### Charred Meat
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Eating char grilled food exposes you to dangerous chemicals called PAHs (polycyclic aromatic hydrocarbons) that have been linked to increased risk for breast cancer. Avoid eating charred meat.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Great! Eating char grilled food exposes you to chemicals that have been linked to increased risk for breast cancer, so keep avoiding them when possible.", :group_id => group_id, :risk_level => lower_risk_level)

charred_meat_question = Question.create(:question_name => "Do you regularly eat charred meat?", :group_id => group_id, :input_type => radio, :category => diet_category)

QuestionOption.create(:question => charred_meat_question, :option_choice => yes_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)
QuestionOption.create(:question => charred_meat_question, :option_choice => no_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

### Alcohol
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Having one or more servings of alcoholic drinks per day increases risk for breast cancer. For women who drink more than one serving per day, their risk is 1.5 times higher than for nondrinkers.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Just getting a drink out with friends every now and then? Not to worry; but having one or more servings of alcoholic drinks per day increases women's risk for breast cancer.", :group_id => group_id, :risk_level => lower_risk_level)

alcohol_question = Question.create(:question_name => "Do you frequently have more than 8 alcoholic drinks per week?", :group_id => group_id, :input_type => radio, :category => diet_category)

QuestionOption.create(:question => alcohol_question, :option_choice => yes_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)
QuestionOption.create(:question => alcohol_question, :option_choice => no_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

### Exercise
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Regardless of a woman's height and weight, regular exercise for 30 minutes or more, most days of the week, has been shown to reduce a woman's risk of breast cancer and results in numerous other health benefits. No more couch potato!", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Wow! Good job on the fitness! By exercising more than 30 minutes most days of the week, you're reducing your risk for breast cancer and getting so many other health benefits.", :group_id => group_id, :risk_level => lower_risk_level)

exercise_question = Question.create(:question_name => "How many days per week do you exercise 30 minutes or more?", :group_id => group_id, :input_type => radio, :category => exercise_category)

for exercise in 0..7
  exercise_option_choice = OptionChoice.create(:option_choice_name => exercise)
  if exercise > 3
    QuestionOption.create(:question => exercise_question, :option_choice => exercise_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)  
  else
    QuestionOption.create(:question => exercise_question, :option_choice => exercise_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)
  end
end

### Fragrances
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Phthalates (pronounced tha-lates) are chemicals found in some personal care products like fragrances, nail polish and hair care products. When possible, use fragrance-free products.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Great! Keep using fragrance-free products when possible.", :group_id => group_id, :risk_level => lower_risk_level)

fragrances_question = Question.create(:question_name => "Do you most often use personal care products like cosmetics with or without fragrances?", :group_id => group_id, :input_type => radio, :category => environment_category)

fragrances_option_choice = OptionChoice.create(:option_choice_name => "With fragrances")
QuestionOption.create(:question => fragrances_question, :option_choice => fragrances_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

fragrances_option_choice = OptionChoice.create(:option_choice_name => "Without fragrances")
QuestionOption.create(:question => fragrances_question, :option_choice => fragrances_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

### Plastics/glass
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Bisphenol A (BPA) and phthalates (pronounced tha-lates) are chemicals in plastic containers and some food packaging. Researchers are investigating their potential links to breast cancer risk. When possible, microwave your food in glass dishes, reduce the use of canned goods and avoid plastic containers with recycle codes 3, 6 and 7.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Good! Keep using glass containers for food whenever you can.", :group_id => group_id, :risk_level => lower_risk_level)

materials_question = Question.create(:question_name => "Do you store, serve or microwave food in plastic or glass dishes?", :group_id => group_id, :input_type => radio, :category => environment_category)

materials_option_choice = OptionChoice.create(:option_choice_name => "Plastic")
QuestionOption.create(:question => materials_question, :option_choice => materials_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

materials_option_choice = OptionChoice.create(:option_choice_name => "Glass")
QuestionOption.create(:question => materials_question, :option_choice => materials_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

### Hormones
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Oral contraceptives and hormone replacement therapy (HRT) increase a woman's lifetime exposure to estrogen, increasing her risk for breast cancer. Avoid prolonged use of menopausal HRT, unless recommended by your doctor.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Great! Oral contraceptives and hormone replacement therapy (HRT) increase a woman's lifetime exposure to estrogen, so avoid prolonged exposure when possible.", :group_id => group_id, :risk_level => lower_risk_level)

hormones_question = Question.create(:question_name => "Have you used oral birth control for 10+ years or hormone replacement therapy for 5+ years?", :group_id => group_id, :input_type => radio, :category => environment_category)

QuestionOption.create(:question => hormones_question, :option_choice => yes_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)
QuestionOption.create(:question => hormones_question, :option_choice => no_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

### Screening: look and feel
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Know the normal look and feel of your breasts so that it is easier to spot possible abnormalities.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Excellent! Knowing the normal look and feel of your breasts makes it easier to spot possible abnormalities.", :group_id => group_id, :risk_level => lower_risk_level)

screening_question = Question.create(:question_name => "Do you know the normal look and feel of your breasts?", :group_id => group_id, :input_type => radio, :category => screening_category)

QuestionOption.create(:question => screening_question, :option_choice => yes_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)
QuestionOption.create(:question => screening_question, :option_choice => no_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

### Screening: talked to physician
group_id += 1
higher_risk_message = RiskMessage.create(:message => "With your physician, discuss your family history, annual exams and the age to start mammograms.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Fantastic! Be sure to discuss your family history, annual exams and the age to start mammograms.", :group_id => group_id, :risk_level => lower_risk_level)

screening_question = Question.create(:question_name => "Have you talked with your personal care physician about your breast health?", :group_id => group_id, :input_type => radio, :category => screening_category)

QuestionOption.create(:question => screening_question, :option_choice => yes_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)
QuestionOption.create(:question => screening_question, :option_choice => no_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

### Screening: breast exams
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Annual breast exams by a physician and mammograms help detect breast cancer early, giving women a better chance for survival. US Preventive Services Task Force recommends that women ages 50-74 get mammograms every two years.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "Great! Annual breast exams by a physician and mammograms help detect breast cancer early, giving women a better chance for survival.", :group_id => group_id, :risk_level => lower_risk_level)

screening_question = Question.create(:question_name => "Have you begun getting clinical breast exams and/or mammograms?", :group_id => group_id, :input_type => radio, :category => screening_category)

QuestionOption.create(:question => screening_question, :option_choice => yes_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)
QuestionOption.create(:question => screening_question, :option_choice => no_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

### BMI
# User isn't explicitly asked BMI, but these rows are used to store the user's BMI as a range with a particular feedback message.
group_id += 1
higher_risk_message = RiskMessage.create(:message => "Having a Body Mass Index (BMI) of 25 or higher increases your risk for breast cancer. Keep reading to learn about changes you can make to your diet and exercise routines to maintain a healthy weight and lower your risk.", :group_id => group_id, :risk_level => higher_risk_level)
lower_risk_message = RiskMessage.create(:message => "sBy maintaining your BMI between 18.5 and 24, you're reducing your risk for postmenopausal breast cancer. Keep reading for more ideas on steps in maintaining a healthy lifestyle and reducing breast cancer risk.", :group_id => group_id, :risk_level => lower_risk_level)

bmi_question = Question.create(:question_name => "Your BMI", :group_id => group_id, :input_type => select, :category => health_history_category)

bmi_option_choice = OptionChoice.create(:option_choice_name => "Underweight (< 18.5)", :option_choice_value => 18.5)
QuestionOption.create(:question => bmi_question, :option_choice => bmi_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

bmi_option_choice = OptionChoice.create(:option_choice_name => "Normal (18.5 - 24.9)", :option_choice_value => 24.9)
QuestionOption.create(:question => bmi_question, :option_choice => bmi_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

bmi_option_choice = OptionChoice.create(:option_choice_name => "Overweight (25 - 29.9)", :option_choice_value => 29.9)
QuestionOption.create(:question => bmi_question, :option_choice => bmi_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

# Max BMI for the height and weight combinations available is 95.79, so provide 100 as the upper limit
bmi_option_choice = OptionChoice.create(:option_choice_name => "Obese (30+)", :option_choice_value => 100)
QuestionOption.create(:question => bmi_question, :option_choice => bmi_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)