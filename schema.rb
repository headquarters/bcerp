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
higher_risk_message = RiskMessage.create(
  :message => "Older women are at higher risk for breast cancer, especially after menopause. Discuss screening and risk reduction steps with your physician.",
  :long_message => "Older women are at higher risk for breast cancer, especially after menopause. Discuss screening and risk reduction steps with your physician. Risk gradually increases as women get older. Breast cancer is most frequently diagnosed among women age 55-64 with more than 2/3 of women diagnosed at 55 years or older.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Older women are at higher risk for breast cancer, but women at any age can get the disease. Talk with your physician to learn steps you can take to reduce your risk AT ANY AGE.",
  :long_message => "Older women are at higher risk for breast cancer, but women at any age can get the disease. Talk with your physician to learn steps you can take to reduce your risk AT ANY AGE. Approximately 11% of women younger than 45 years old are diagnosed with breast cancer each year. The Centers for Disease Control and Prevention recognizes breast cancer for young women as a very overwhelming challenge, making it important for young women to discuss their breast health with their physicians.",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

age_question = Question.create(
  :question_name => "How old are you?",
  :group_id => group_id,
  :input_type => select,
  :category => health_history_category
)

age_option_choice = OptionChoice.create(:option_choice_name => "Younger than 20")

QuestionOption.create(
  :question => age_question,
  :option_choice => age_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => lower_risk_message
)

age = 20

while age < 70
  age_range = "#{age}-#{age + 4}"
  
  age_option_choice = OptionChoice.create(:option_choice_name => age_range)
  
  if age < 45
    QuestionOption.create(
      :question => age_question,
      :option_choice => age_option_choice,
      :risk_level => lower_risk_level,
      :risk_message => lower_risk_message
    )
  else
    QuestionOption.create(
      :question => age_question,
      :option_choice => age_option_choice,
      :risk_level => higher_risk_level,
      :risk_message => higher_risk_message
    )
  end
  
  age = age + 5
end

age_option_choice = OptionChoice.create(:option_choice_name => "70+")

QuestionOption.create(
  :question => age_question,
  :option_choice => age_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)




Resource.create(
  :text => '<a href="http://www.cdc.gov/cancer/breast/pdf/BreastCancer_YoungWomen_FactSheet.pdf">Breast Cancer in Young Women fact sheet (PDF)</a>',
  :group_id => group_id  
)

Resource.create(
  :text => '<a href="http://womenshealth.gov/aging/">US DHHS Office of Women\'s Health&mdash;Healthy Aging</a>',
  :group_id => group_id  
)

### Race/Ethnicity
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "African-American women under 50 are more commonly diagnosed with basal-like breast cancer (also known as triple negative breast cancer), a fast-growing cancer. Keep reading for information on when to start breast cancer screening and other steps to reduce risk, and discuss your risk with your doctor.",
  :long_message => "African-American women under 50 are more commonly diagnosed with basal-like breast cancer (also known as triple negative breast cancer), a fast-growing cancer. Keep reading for information on when to start breast cancer screening and other steps to reduce risk, and discuss your risk with your doctor. Although more Caucasian women are diagnosed with breast cancer, the death rate is 41% higher among African American women in the US. Basal-like breast cancer is a fast-growing subtype of breast cancer.  Most basal-like breast cancers are also triple negative breast cancer subtypes, meaning that these cancers make low levels of three proteins that are usually targeted in breast cancer treatment.  Fewer treatment options are available for these cancers, so studies are needed to find better treatments for these cancers.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

race_question = Question.create(
  :question_name => "With which race/ethnicity do you identify?",
  :group_id => group_id,
  :input_type => radio,
  :category => health_history_category
)

race_option_choice1 = OptionChoice.create(:option_choice_name => "Black/African American")
QuestionOption.create(
  :question => race_question,
  :option_choice => race_option_choice1,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

race_option_choice2 = OptionChoice.create(:option_choice_name => "White")
QuestionOption.create(
  :question => race_question,
  :option_choice => race_option_choice2,
  :risk_level => no_risk_level
)

race_option_choice3 = OptionChoice.create(:option_choice_name => "Hispanic/Latin American")
QuestionOption.create(
  :question => race_question,
  :option_choice => race_option_choice3,
  :risk_level => no_risk_level
)

race_option_choice4 = OptionChoice.create(:option_choice_name => "American/Pacific Islander")
QuestionOption.create(
  :question => race_question,
  :option_choice => race_option_choice4,
  :risk_level => no_risk_level
)

race_option_choice5 = OptionChoice.create(:option_choice_name => "Asian")
QuestionOption.create(
  :question => race_question,
  :option_choice => race_option_choice5,
  :risk_level => no_risk_level
)

race_option_choice6 = OptionChoice.create(:option_choice_name => "Other")
QuestionOption.create(
  :question => race_question,
  :option_choice => race_option_choice6,
  :risk_level => no_risk_level
)

Resource.create(
  :text => '<a href="http://cbcs.web.unc.edu/">UNC Lineberger Comprehensive Cancer Center&mdash;The Carolina Breast Cancer Study</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://sisterstudy.niehs.nih.gov/English/index1.htm">NIEHS&mdash;The Sister Study</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.sistersnetworkinc.org/">Sisters Network Inc.</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.wellbodystudy.org/">UNC Chapel Hill&mdash;The Well Body Study</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://ww5.komen.org/uploadedFiles/Content_Binaries/KOMEED079100.pdf">Susan G. Komen&mdash;Triple Negative Breast Cancer (PDF)</a>',
  :group_id => group_id
)


### Children
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Having no children or having a first child after 35 increases breast cancer risk, because your lifetime exposure to estrogen is higher with no or later pregnancies. Most risks for breast cancer are associated with lifetime exposure to estrogen.",
  :long_message => "Having no children or having a first child after 35 increases breast cancer risk, because your lifetime exposure to estrogen is higher with no or later pregnancies. Most known risks for breast cancer are associated with lifetime exposure to estrogen. Estrogen is a naturally occurring hormone important for sexual development and childbearing. A woman's exposure to estrogen varies over her lifetime. Estrogen exposure may change the state or number of cells that could become cancerous.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Having children before age 35 decreases breast cancer risk. Keep reading and talk with your doctor about steps you can take to reduce your risk.",
  :long_message => "Having children before age 35 decreases breast cancer risk. Keep reading and talk with your doctor about steps you can take to reduce your risk. Estrogen is a naturally occurring hormone important for sexual development and childbearing. A woman's exposure to estrogen varies over her lifetime. Estrogen exposure may change the state or number of cells that could become cancerous. Breast cancer risk declines with the number of children women bear.",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

children_question = Question.create(
  :question_name => "How old were you when your first child was born?",
  :group_id => group_id,
  :input_type => radio,
  :category => health_history_category
)

no_children_option_choice = OptionChoice.create(:option_choice_name => "I have no children")
QuestionOption.create(
  :question => children_question,
  :option_choice => no_children_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

children_option_choice = OptionChoice.create(:option_choice_name => "Younger than 35")
QuestionOption.create(
  :question => children_question,
  :option_choice => children_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => lower_risk_message
)

children_option_choice = OptionChoice.create(:option_choice_name => "35 or older")
QuestionOption.create(
  :question => children_question,
  :option_choice => children_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

Resource.create(
  :text => '<a href="http://www.cancer.gov/cancertopics/wyntk/breast/WYNTK_breast.pdf ">NCI&mdash;What You Need to Know about Breast Cancer (PDF)</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://info.bcerp.org/">NIEHS&mdash;Breast Cancer and the Environment Fact Sheet: The Puberty Connection</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.breastcancerfund.org/assets/pdfs/publications/falling-age-of-puberty-adv-guide.pdf">Breast Cancer Fund&mdash;The Falling Age of Puberty in U.S. Girls: What We Know, What We Need to Know (PDF)</a>',
  :group_id => group_id
)

### Breastfeeding
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Having no children or breastfeeding for less than 12 months across all children increases your exposure to estrogen. Most risks for breast cancer are associated with lifetime exposure to estrogen.",
  :long_message => "Having no children or breastfeeding for less than 12 months across all children increases your exposure to estrogen. Most risks for breast cancer are associated with lifetime exposure to estrogen. Breastfeeding lowers a woman's estrogen levels. Research shows that women who breastfeed have lower breast cancer risk than women who have children but do not breastfeed. (NCI) In addition to protecting women's health, breastfeeding provides nutrients and antibodies to help infants fight disease.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Good! Breastfeeding for more than 12 months across all children decreases your risk, and it protects your child's health, too.",
  :long_message => "Good! Breastfeeding for more than 12 months across all children decreases your risk, and it protects your child's health, too. Breastfeeding lowers a woman's estrogen levels. Research shows that women who breastfeed have lower breast cancer risk than women who have children but do not breastfeed. (NCI) In addition to protecting women's health, breastfeeding provides nutrients and antibodies to help infants fight disease.",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

breastfeeding_question = Question.create(
  :question_name => "How many months (total) did you breast feed across all your children?",
  :group_id => group_id,
  :input_type => radio,
  :category => health_history_category
)

QuestionOption.create(
  :question => breastfeeding_question,
  :option_choice => no_children_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

breastfeeding_option_choice = OptionChoice.create(:option_choice_name => "0-11 months")
QuestionOption.create(
  :question => breastfeeding_question,
  :option_choice => breastfeeding_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

breastfeeding_option_choice = OptionChoice.create(:option_choice_name => "12+ months")
QuestionOption.create(
  :question => breastfeeding_question,
  :option_choice => breastfeeding_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => lower_risk_message
)

Resource.create(
  :text => '<a href="http://www.womenshealth.gov/breastfeeding/">US DHHS Office of Women\'s Health&mdash;Breastfeeding</a>',
  :group_id => group_id  
)

Resource.create(
  :text => '<a href="http://www.surgeongeneral.gov/library/calls/breastfeeding/factsheet.html">Surgeon general\'s call to support breastfeeding&mdash;fact sheet</a>',
  :group_id => group_id  
)

### Relatives
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Women have higher breast cancer risk if first degree relatives (mom, dad, sister, brother, son, daughter) have a history of breast cancer.",
  :long_message => "Women have higher breast cancer risk if first degree relatives (mom, dad, sister, brother, son, daughter) have a history of breast cancer. Other risk factors involving family history include having a first degree relative with breast or ovarian cancer before age 50 and having a first degree relative with cancer in both breasts.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Having no first degree relatives with a history of breast cancer does lower your risk, but does not eliminate it.",
  :long_message => "Having no first degree relatives with a history of breast cancer does lower your risk, but does not eliminate it. Other risk factors involving family history include having a first degree relative with breast or ovarian cancer before age 50 and having a first degree relative with cancer in both breasts.", 
  :group_id => group_id,
  :risk_level => lower_risk_level
)

relatives_question = Question.create(
  :question_name => "Have any of your first-degree relatives (mother, sister, daughter, father, brother, or son) ever had breast or ovarian cancer?",
  :group_id => group_id,
  :input_type => radio,
  :category => health_history_category
)

yes_option_choice = OptionChoice.create(:option_choice_name => "Yes")
QuestionOption.create(
  :question => relatives_question,
  :option_choice => yes_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

no_option_choice = OptionChoice.create(:option_choice_name => "No")
QuestionOption.create(
  :question => relatives_question,
  :option_choice => no_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => higher_risk_message
)

Resource.create(
  :text => '<a href="http://www.cdc.gov/features/hereditarycancer/">Centers for Disease Control and Prevention</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://sisterstudy.niehs.nih.gov/English/index1.htm">NIH&mdash;The Sister Study</a>',
  :group_id => group_id
)

### Height
# No inherent risk level associated with height. See BMI.
group_id += 1
height_question = Question.create(
  :question_name => "How tall are you (in feet and inches)?",
  :group_id => group_id,
  :input_type => select,
  :category => health_history_category
)

height_option_choice = OptionChoice.create(:option_choice_name => "Less than 4'", :option_choice_value => 47.0)
QuestionOption.create(
  :question => height_question,
  :option_choice => height_option_choice,
  :risk_level => no_risk_level
)

for feet in 4..6
  for inches in 0..11
    if(inches == 0)
      name = "#{feet}'"
    else
      name = "#{feet}' #{inches}\""
    end
    total_inches = (feet * 12) + inches
    height_option_choice = OptionChoice.create(:option_choice_name => name, :option_choice_value => total_inches)
    QuestionOption.create(
      :question => height_question,
      :option_choice => height_option_choice,
      :risk_level => no_risk_level
    )
  end  
end

height_option_choice = OptionChoice.create(:option_choice_name => "More than 6'", :option_choice_value => 71.0)

QuestionOption.create(
  :question => height_question,
  :option_choice => height_option_choice,
  :risk_level => no_risk_level
)

### Weight
# No inherent risk level associated with weight. See BMI.

weight_question = Question.create(
  :question_name => "How much do you weigh (in pounds)?",
  :group_id => group_id,
  :input_type => select,
  :category => health_history_category
)

weight_option_choice = OptionChoice.create(:option_choice_name => "Less than 90", :option_choice_value => 89.0)
QuestionOption.create(
  :question => weight_question,
  :option_choice => weight_option_choice,
  :risk_level => no_risk_level
)

for weight in 90..299
  # use same weight as String presented to user (name) and Integer used for calculation (value)
  weight_option_choice = OptionChoice.create(:option_choice_name => weight, :option_choice_value => weight)
  QuestionOption.create(
    :question => weight_question,
    :option_choice => weight_option_choice,
    :risk_level => no_risk_level
  )
end

weight_option_choice = OptionChoice.create(:option_choice_name => "300+", :option_choice_value => 301.0)
QuestionOption.create(
  :question => weight_question,
  :option_choice => weight_option_choice,
  :risk_level => no_risk_level
)


### Diet Habits
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Eating a diet with at least 5 servings of fruits and vegetables each day has been shown to be protective against developing breast cancer. Eat those fruits and veggies!",
  :long_message => "Eating a diet with at least 5 servings of fruits and vegetables each day has been shown to be protective against developing breast cancer. Eat those fruits and veggies! The 2010 US Dietary Guidelines recommend controlling the amount of calories you take in each day and increasing your nutrient-dense foods and drinks, such as whole grains, fruits, vegetables, low fat dairy products and lean meats.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Wow! Your dietary habits are on target! Eating a diet with at least 5 servings of fruits and vegetables each day has been shown to be protective against developing breast cancer. Keep up the good work!",
  :long_message => "Wow! Your dietary habits are on target! Eating a diet with at least 5 servings of fruits and vegetables each day has been shown to be protective against developing breast cancer. Keep up the good work! The 2010 US Dietary Guidelines recommend controlling the amount of calories you take in each day and increasing your nutrient-dense foods and drinks, such as whole grains, fruits, vegetables, low fat dairy products and lean meats.",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

diet_habits_question = Question.create(
  :question_name => "How would you describe your dietary habits?",
  :group_id => group_id,
  :input_type => radio,
  :category => diet_category
)

diet_option_choice = OptionChoice.create(:option_choice_name => "You eat a well-balanced, low-fat diet.")
QuestionOption.create(
  :question => diet_habits_question,
  :option_choice => diet_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => lower_risk_message
)

diet_option_choice = OptionChoice.create(:option_choice_name => "You eat some high-fat and junk food a few times a week.")
QuestionOption.create(
  :question => diet_habits_question,
  :option_choice => diet_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

diet_option_choice = OptionChoice.create(:option_choice_name => "You regularly eat high-fat and junk food.")
QuestionOption.create(
  :question => diet_habits_question,
  :option_choice => diet_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

Resource.create(
  :text => '<a href="http://www.iom.edu/~/media/Files/Report%20Files/2011/Breast-Cancer-Environment/BreastCancerReportbrief_2.pdf">Institute of Medicine&mdash;Breast Cancer and the Environment: A Life Course Approach (PDF)</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.choosemyplate.gov/">Choose My Plate</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.cnpp.usda.gov/DGAs2010-PolicyDocument.htm">Dietary Guidelines for Americans</a>',
  :group_id => group_id
)

### Fresh/frozen foods
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Fresh and frozen foods are healthier alternatives to canned foods.",
  :long_message => "Fresh and frozen foods are healthier alternatives to canned foods. Bisphenol A (BPA) is a chemical in plastic containers and in the lining of some canned goods. Research supported by the National Institutes of Health is ongoing to explore whether these chemicals influence the development of girls' bodies and their risk for breast cancer. So serve your entire family meals made from frozen or fresh foods.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Good! Fresh and frozen foods are healthier alternatives to canned foods.",
  :long_message => "Good! Fresh and frozen foods are healthier alternatives to canned foods. Bisphenol A (BPA) is a chemical in plastic containers and in the lining of some canned goods. Research supported by the National Institutes of Health is ongoing to explore whether these chemicals influence the development of girls' bodies and their risk for breast cancer. So keep serving the entire family meals made from frozen or fresh foods.",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

fresh_or_frozen_question = Question.create(
  :question_name => "Do you most often eat fresh/frozen foods or canned?",
  :group_id => group_id,
  :input_type => radio,
  :category => diet_category
)

ff_option_choice = OptionChoice.create(:option_choice_name => "Fresh/frozen foods")
QuestionOption.create(
  :question => fresh_or_frozen_question,
  :option_choice => ff_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => lower_risk_message
)

ff_option_choice = OptionChoice.create(:option_choice_name => "Canned foods")
QuestionOption.create(
  :question => fresh_or_frozen_question,
  :option_choice => ff_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

Resource.create(
  :text => '<a href="http://info.bcerp.org/AA/BCERP_Brochure__AA_VerA_Final.pdf">NIEHS Breast Cancer and the Environment Resource Program (PDF)</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.niehs.nih.gov/health/assets/docs_a_e/bisphenol_a_bpa_508.pdf">NIEHS National Toxicology Program&mdash;Bisphenol A (BPA) Fact Sheet (PDF)</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="https://www.mountsinai.org/static_files/MSMC/Files/Patient%20Care/Children/Childrens%20Environmental%20Health%20Center/Fact%20Sheet%20-%20Plastic&BPA.pdf">Mt. Sinai Children\'s Environmental Health Center&mdash;"Check the Kind of Plastics You Use" (PDF)</a>',
  :group_id => group_id
)

### Charred Meat
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Eating char grilled food exposes you to dangerous chemicals called PAHs (polycyclic aromatic hydrocarbons) that have been linked to increased risk for breast cancer. Avoid eating charred meat.",
  :long_message => "Eating char grilled food exposes you to dangerous chemicals called PAHs (polycyclic aromatic hydrocarbons) that have been linked to increased risk for breast cancer. Avoid eating charred meat. PAHs are formed when the fat from meats are grilled at high temperatures over open flames. Increases in cooking temperature, the amount of fat in the meat, and the time that the meat is cooked increases the concentration of these chemicals. To reduce exposure to PAHs, lower the cooking temperature, grill leaner meat, avoid eating charred parts of the meat, and use a thermometer to know when the meat is done.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Great! Eating char grilled food exposes you to chemicals that have been linked to increased risk for breast cancer, so keep avoiding them when possible.",
  :long_message => "Great! Eating char grilled food exposes you to chemicals that have been linked to increased risk for breast cancer, so keep avoiding them when possible. PAHs (polycyclic aromatic hydrocarbons) are formed when the fat from meats are grilled at high temperatures over open flames. Increases in cooking temperature, the amount of fat in the meat, and the time that the meat is cooked increases the concentration of these chemicals. To reduce exposure to PAHs, lower the cooking temperature, grill leaner meat, avoid eating charred parts of the meat, and use a thermometer to know when the meat is done.",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

charred_meat_question = Question.create(
  :question_name => "Do you regularly eat charred meat?",
  :group_id => group_id,
  :input_type => radio, :category => diet_category
)

QuestionOption.create(
  :question => charred_meat_question,
  :option_choice => yes_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

QuestionOption.create(
  :question => charred_meat_question,
  :option_choice => no_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => lower_risk_message
)

Resource.create(
  :text => '<a href="http://www.breastcancer.org/risk/factors/grilled_food">Breastcancer.org</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.foodsafety.wisc.edu/assets/pdf_Files/FFH_Reducing%20Cancer%20Risk%20from%20Grilled%20Meats.pdf">University of Wisconsin at Madison&mdash;Fact sheet&mdash;Reducing Cancer Risk from Grilled Meat (PDF)</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.cancer.gov/cancertopics/factsheet/Risk/cooked-meats">NCI&mdash;Chemicals in Meat Cooked at High Temperatures and Cancer Risk</a>',
  :group_id => group_id
)


### Alcohol
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Having one or more servings of alcoholic drinks per day increases risk for breast cancer. For women who drink more than one serving per day, their risk is 1.5 times higher than for nondrinkers.",
  :long_message => "Having one or more servings of alcoholic drinks per day increases risk for breast cancer. For women who drink more than one serving per day, their risk is 1.5 times higher than for nondrinkers. A recent study published by the National Cancer Institute showed a 30-60% increase in risk for women who drink more than one drink each day.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Just getting a drink out with friends every now and then? Not to worry; but having one or more servings of alcoholic drinks per day increases women's risk for breast cancer.",
  :long_message => "Just getting a drink out with friends every now and then? Not to worry; but having one or more servings of alcoholic drinks per day increases women's risk for breast cancer. A recent study published by the National Cancer Institute showed a 30-60% increase in risk for women who drink more than one drink each day.",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

alcohol_question = Question.create(
  :question_name => "Do you frequently have more than 8 alcoholic drinks per week?",
  :group_id => group_id,
  :input_type => radio,
  :category => diet_category
)

QuestionOption.create(
  :question => alcohol_question,
  :option_choice => yes_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

QuestionOption.create(
  :question => alcohol_question,
  :option_choice => no_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => lower_risk_message
)

Resource.create(
  :text => '<a href="http://rethinkingdrinking.niaaa.nih.gov/whatcountsdrink/whatsastandarddrink.asp">National Institute on Alcohol Abuse and Alcoholism&mdash;Rethinking Drinking&mdash;What\'s a standard drink?</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://rethinkingdrinking.niaaa.nih.gov/whatcountsdrink/HowManyDrinksAreInCommonContainers.asp">NIAAA&mdash;Rethinking Drinking&mdash;How many drinks are in common containers?</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://rethinkingdrinking.niaaa.nih.gov/Strategies/TipsToTry.asp">NIAAA&mdash;Tips to try for limiting consumption</a>',
  :group_id => group_id
)


### Exercise
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Regardless of a woman's height and weight, regular exercise for 30 minutes or more, most days of the week, has been shown to reduce a woman's risk of breast cancer and results in numerous other health benefits. No more couch potato!",
  :long_message => "Regardless of a woman's height and weight, regular exercise for 30 minutes or more, most days of the week, has been shown to reduce a woman's risk of breast cancer and results in numerous other health benefits. No more couch potato! Recent studies show that women reduce their risk by as much as 30% with regular exercise, with better results shown for women with increased exercise times and intensity. However, studies also show that women experience lower breast cancer risk and other health benefits, regardless of intensity. Use these resources for ideas to increase your physical activity.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Wow! Good job on the fitness! By exercising more than 30 minutes most days of the week, you're reducing your risk for breast cancer and getting so many other health benefits.",
  :long_message => "Wow! Good job on the fitness! By exercising more than 30 minutes most days of the week, you're reducing your risk for breast cancer and getting so many other health benefits. Recent studies show that women reduce their risk by as much as 30% with regular exercise, with better results shown for women with increased exercise times and intensity. However, studies also show that women experience lower breast cancer risk and other health benefits, regardless of intensity. Use these resources for even more ideas to keep your physical activity on track.",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

exercise_question = Question.create(
  :question_name => "How many days per week do you exercise 30 minutes or more?",
  :group_id => group_id,
  :input_type => radio,
  :category => exercise_category
)

for exercise in 0..7
  exercise_option_choice = OptionChoice.create(:option_choice_name => exercise)
  if exercise > 3
    QuestionOption.create(
      :question => exercise_question,
      :option_choice => exercise_option_choice,
      :risk_level => lower_risk_level,
      :risk_message => lower_risk_message
    )  
  else
    QuestionOption.create(
      :question => exercise_question,
      :option_choice => exercise_option_choice,
      :risk_level => higher_risk_level,
      :risk_message => higher_risk_message
    )
  end
end

Resource.create(
  :text => '<a href="http://www.choosemyplate.gov/physical-activity/increase-physical-activity.html">Choose My Plate&mdash;Tips for Increasing Physical Activity</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.cdc.gov/physicalactivity/">Centers for Disease Control and Prevention&mdash;Physical Activity</a>',
  :group_id => group_id
)

### Fragrances
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Phthalates (pronounced tha-lates) are chemicals found in some personal care products like fragrances, nail polish and hair care products. When possible, use fragrance-free products.",
  :long_message => "Phthalates (pronounced tha-lates) are chemicals found in some personal care products like fragrances, nail polish and hair care products. When possible, use fragrance-free products. Research supported by the National Institutes of Health is ongoing to explore whether these chemicals influence the development of girls' bodies and their risk for breast cancer. Use the following resources for ideas to reduce exposure to these chemicals.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Great! Keep using fragrance-free products when possible.",
  :long_message => "Great! Keep using fragrance-free products when possible. Phthalates (pronounced tha-lates) are chemicals found in some personal care products like fragrances, nail polish and hair care products. Research supported by the National Institutes of Health is ongoing to explore whether these chemicals influence the development of girls' bodies and their risk for breast cancer. Use the following resources for ideas on other ways to reduce exposure to these chemicals.",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

fragrances_question = Question.create(
  :question_name => "Do you most often use personal care products like cosmetics with or without fragrances?",
  :group_id => group_id,
  :input_type => radio,
  :category => environment_category
)

fragrances_option_choice = OptionChoice.create(:option_choice_name => "With fragrances")
QuestionOption.create(
  :question => fragrances_question,
  :option_choice => fragrances_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

fragrances_option_choice = OptionChoice.create(:option_choice_name => "Without fragrances")
QuestionOption.create(
  :question => fragrances_question,
  :option_choice => fragrances_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => lower_risk_message
)

Resource.create(
  :text => '<a href="http://info.bcerp.org/AA/BCERP_Brochure__AA_VerA_Final.pdf">NIEHS Breast Cancer and the Environment Resource Program (PDF)</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://info.bcerp.org/">NIEHS BCERP&mdash;Fact Sheet: The Chemical Connection</a>',
  :group_id => group_id
)

### Plastics/glass
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Bisphenol A (BPA) and phthalates (pronounced tha-lates) are chemicals in plastic containers and some food packaging. Researchers are investigating their potential links to breast cancer risk. When possible, microwave your food in glass dishes, reduce the use of canned goods and avoid plastic containers with recycle codes 3, 6 and 7.",
  :long_message => "Bisphenol A (BPA) and phthalates (pronounced tha-lates) are chemicals in plastic containers and some food packaging. Researchers are investigating their potential links to breast cancer risk. When possible, microwave your food in glass dishes, reduce the use of canned goods and avoid plastic containers with recycle codes 3, 6 and 7. Follow these resources for additional ideas for avoiding these chemicals.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Good! Keep using glass containers for food whenever you can.",
  :long_message => "Good! Keep using glass containers for food whenever you can. Bisphenol A (BPA) and phthalates (pronounced tha-lates) are chemicals in plastic containers and some food packaging. Researchers are investigating their potential links to breast cancer risk. In addition to microwaving your food in glass dishes, you should also reduce the use of canned goods and avoid plastic containers with recycle codes 3, 6 and 7.",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

materials_question = Question.create(
  :question_name => "Do you store, serve or microwave food in plastic or glass dishes?",
  :group_id => group_id,
  :input_type => radio,
  :category => environment_category
)

materials_option_choice = OptionChoice.create(:option_choice_name => "Plastic")
QuestionOption.create(
  :question => materials_question,
  :option_choice => materials_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

materials_option_choice = OptionChoice.create(:option_choice_name => "Glass")
QuestionOption.create(
  :question => materials_question,
  :option_choice => materials_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => lower_risk_message
)

Resource.create(
  :text => '<a href="http://info.bcerp.org/AA/BCERP_Brochure__AA_VerA_Final.pdf">NIEHS Breast Cancer and the Environment Resource Program (PDF)</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="https://www.mountsinai.org/static_files/MSMC/Files/Patient%20Care/Children/Childrens%20Environmental%20Health%20Center/Fact%20Sheet%20-%20Plastic&BPA.pdf">Mt. Sinai Children\'s Environmental Health Center&mdash;"Check the Kind of Plastics You Use" (PDF)</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.niehs.nih.gov/health/assets/docs_a_e/bisphenol_a_bpa_508.pdf">NIEHS National Toxicology Program&mdash;Bisphenol A (BPA) Fact Sheet (PDF)</a>',
  :group_id => group_id
)


### Hormones
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Oral contraceptives and hormone replacement therapy (HRT) increase a woman's lifetime exposure to estrogen, increasing her risk for breast cancer. Avoid prolonged use of menopausal HRT, unless recommended by your doctor.",
  :long_message => "Oral contraceptives and menopausal hormone therapy (MHT) increase a woman's lifetime exposure to estrogen, increasing her risk for breast cancer. Avoid prolonged use of menopausal HRT, unless recommended by your doctor. MHT, which is typically taken to relieve women of symptoms associated with menopause, has also been found to increase a woman's risk for heart disease and other serious illnesses. If used, MHT should be used for a brief amount of time.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Great! Oral contraceptives and hormone replacement therapy (HRT) increase a woman's lifetime exposure to estrogen, so avoid prolonged exposure when possible.",
  :long_message => "Great! Oral contraceptives and menopausal hormone therapy (MHT) increase a woman's lifetime exposure to estrogen, so avoid prolonged exposure when possible. MHT, which is typically taken to relieve women of symptoms associated with menopause, has also been found to increase a woman's risk for heart disease and other serious illnesses. If used, MHT should be used for a brief amount of time.",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

hormones_question = Question.create(
  :question_name => "Have you used oral birth control for 10+ years or hormone replacement therapy for 5+ years?",
  :group_id => group_id,
  :input_type => radio,
  :category => environment_category
)

QuestionOption.create(
  :question => hormones_question,
  :option_choice => yes_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

QuestionOption.create(
  :question => hormones_question,
  :option_choice => no_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => lower_risk_message
)

Resource.create(
  :text => '<a href="http://ww5.komen.org/uploadedFiles/Content_Binaries/806-370.pdf">Susan G. Komen&mdash;How Hormones affect Breast Cancer (PDF)</a>',
  :group_id => group_id
)

### Screening: look and feel
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Know the normal look and feel of your breasts so that it is easier to spot possible abnormalities.",
  :long_message => "Know the normal look and feel of your breasts so that it is easier to spot possible abnormalities. Possible changes can occur in a woman's breasts, and women should ask their doctors about any noticed changes. Some specific changes that can occur include: a breast or underarm lump or firmness, an inverted or tender nipple, nipple discharge, or scaly, red or swollen skin on the breast, nipple or areola.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Excellent! Knowing the normal look and feel of your breasts makes it easier to spot possible abnormalities.",
  :long_message => "Excellent! Knowing the normal look and feel of your breasts makes it easier to spot possible abnormalities. Women should be aware of possible changes in their breasts, and they should ask their doctors about any noticed changes. Some specific changes that can occur include: a breast or underarm lump or firmness, an inverted or tender nipple, nipple discharge, or scaly, red or swollen skin on the breast, nipple or areola.",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

screening_question = Question.create(
  :question_name => "Do you know the normal look and feel of your breasts?",
  :group_id => group_id,
  :input_type => radio,
  :category => screening_category
)

QuestionOption.create(
  :question => screening_question,
  :option_choice => yes_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => lower_risk_message
)

QuestionOption.create(
  :question => screening_question,
  :option_choice => no_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

Resource.create(
  :text => '<a href="http://www.cancer.gov/cancertopics/screening/understanding-breast-changes/understanding-breast-changes.pdf">NCI&mdash;Understanding Breast Changes: A Health Guide for Women (PDF)</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.uspreventiveservicestaskforce.org/uspstf09/breastcancer/brcanrs.pdf">US Preventive Services Task Force Screening Recommendations (PDF)</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://apps.nccd.cdc.gov/dcpc_Programs/default.aspx?NPID=1">National Breast and Cervical Cancer Early Detection Program (screening options for low income women)</a>',
  :group_id => group_id
)

### Screening: talked to physician
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "With your physician, discuss your family history, annual exams and the age to start mammograms.",
  :long_message => "With your physician, discuss your family history, annual exams and the age to start mammograms. Talking with your physician about getting annual exams and the age to start getting mammograms has proven to be proactive in addressing your breast health and breast cancer.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Fantastic! Be sure to discuss your family history, annual exams and the age to start mammograms.",
  :long_message => "Fantastic! Be sure to discuss your family history, annual exams and the age to start mammograms. Talking with your physician about getting annual exams and the age to start getting mammograms has proven to be proactive in addressing your breast health and breast cancer. Encourage your friends and family to take steps to protect their health too!",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

screening_question = Question.create(
  :question_name => "Have you talked with your personal care physician about your breast health?",
  :group_id => group_id,
  :input_type => radio,
  :category => screening_category
)

QuestionOption.create(
  :question => screening_question,
  :option_choice => yes_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => lower_risk_message
)

QuestionOption.create(
  :question => screening_question,
  :option_choice => no_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)



Resource.create(
  :text => '<a href="http://cancercenters.cancer.gov/cancer_centers/index.html">National Cancer Institute&mdash;Cancer Centers</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.uspreventiveservicestaskforce.org/uspstf09/breastcancer/brcanrs.pdf">US Preventive Services Task Force Screening Recommendations (PDF)</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://apps.nccd.cdc.gov/dcpc_Programs/default.aspx?NPID=1">National Breast and Cervical Cancer Early Detection Program (screening options for low income women)</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.cancer.org/">Finding local American Cancer Society branch</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.breastcancer.org/questions/support">Local breast cancer support groups</a>',
  :group_id => group_id
)

### Screening: breast exams
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Annual breast exams by a physician and mammograms help detect breast cancer early, giving women a better chance for survival. US Preventive Services Task Force recommends that women ages 50-74 get mammograms every two years.",
  :long_message => "Annual breast exams by a physician and mammograms help detect breast cancer early, giving women a better chance for survival. US Preventive Services Task Force recommends that women ages 50-74 get mammograms every two years. However, women of all ages should be aware of the feel and look of their breasts and their family history. To be proactive in addressing your breast health and breast cancer, talk with your physician about getting annual exams and the age to start getting mammograms.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "Great! Annual breast exams by a physician and mammograms help detect breast cancer early, giving women a better chance for survival.",
  :long_message => "Great! Annual breast exams by a physician and mammograms help detect breast cancer early, giving women a better chance for survival. Use the following resources for information on breast cancer resources in your area, and encourage your family and friends to protect their health too!",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

screening_question = Question.create(
  :question_name => "Have you begun getting clinical breast exams and/or mammograms?",
  :group_id => group_id,
  :input_type => radio,
  :category => screening_category
)

QuestionOption.create(
  :question => screening_question,
  :option_choice => yes_option_choice,
  :risk_level => lower_risk_level,
  :risk_message => lower_risk_message
)

QuestionOption.create(
  :question => screening_question,
  :option_choice => no_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

Resource.create(
  :text => '<a href="http://cancercenters.cancer.gov/cancer_centers/index.html">National Cancer Institute&mdash;Cancer Centers</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.uspreventiveservicestaskforce.org/uspstf09/breastcancer/brcanrs.pdf">US Preventive Services Task Force Screening Recommendations (PDF)</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://apps.nccd.cdc.gov/dcpc_Programs/default.aspx?NPID=1">National Breast and Cervical Cancer Early Detection Program (screening options for low income women)</a>',
  :group_id => group_id
)
Resource.create(
  :text => '<a href="http://www.cancer.org/">Finding local American Cancer Society branch</a>',
  :group_id => group_id
)

Resource.create(
  :text => '<a href="http://www.breastcancer.org/questions/support">Local breast cancer support groups</a>',
  :group_id => group_id
)

### BMI
# User isn't explicitly asked BMI, but these rows are used to store the user's BMI as a range with a particular feedback message.
group_id += 1
higher_risk_message = RiskMessage.create(
  :message => "Having a Body Mass Index (BMI) of 25 or higher increases your risk for breast cancer. Keep reading to learn about changes you can make to your diet and exercise routines to maintain a healthy weight and lower your risk.",
  :long_message => "Having a Body Mass Index (BMI) of 25 or higher increases your risk for breast cancer. Keep reading to learn about changes you can make to your diet and exercise routines to maintain a healthy weight and lower your risk. Recent studies have shown that women who maintain a normal body weight, with a BMI between 18.5 and 24, decrease their risk for breast cancer by as much as 40%. Eating a well-balanced, healthy diet, with at least five servings of fruit and vegetables daily and moderate to vigorous exercise at least 30 minutes most days will contribute to getting a normal weight, improved health and reduced risk for breast cancer.",
  :group_id => group_id,
  :risk_level => higher_risk_level
)

lower_risk_message = RiskMessage.create(
  :message => "By maintaining your BMI between 18.5 and 24, you're reducing your risk for postmenopausal breast cancer. Keep reading for more ideas on steps in maintaining a healthy lifestyle and reducing breast cancer risk.",
  :long_message => "By maintaining your BMI between 18.5 and 24, you're reducing your risk for postmenopausal breast cancer. Keep reading for more ideas on steps in maintaining a healthy lifestyle and reducing breast cancer risk. Eating a well-balanced, healthy diet, with at least five servings of fruit and vegetables daily and moderate to vigorous exercise at least 30 minutes most days will contribute to getting a normal weight, improved health and reduced risk for breast cancer.",
  :group_id => group_id,
  :risk_level => lower_risk_level
)

bmi_question = Question.create(
  :question_name => "BMI (Body Mass Index)",
  :group_id => group_id,
  :input_type => select,
  :category => health_history_category
)

bmi_option_choice = OptionChoice.create(:option_choice_name => "Underweight (< 18.5)", :option_choice_value => 18.5)
QuestionOption.create(:question => bmi_question, :option_choice => bmi_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

bmi_option_choice = OptionChoice.create(:option_choice_name => "Normal (18.5 - 24.9)", :option_choice_value => 24.9)
QuestionOption.create(:question => bmi_question, :option_choice => bmi_option_choice, :risk_level => lower_risk_level, :risk_message => lower_risk_message)

bmi_option_choice = OptionChoice.create(:option_choice_name => "Overweight (25 - 29.9)", :option_choice_value => 29.9)
QuestionOption.create(:question => bmi_question, :option_choice => bmi_option_choice, :risk_level => higher_risk_level, :risk_message => higher_risk_message)

# Max BMI for the height and weight combinations available is 95.79, so provide 100 as the upper limit
bmi_option_choice = OptionChoice.create(:option_choice_name => "Obese (30+)", :option_choice_value => 100)
QuestionOption.create(
  :question => bmi_question,
  :option_choice => bmi_option_choice,
  :risk_level => higher_risk_level,
  :risk_message => higher_risk_message
)

Resource.create(
  :text => '<a href="http://health.gov/bmi/">Calculating Your BMI</a>',
  :group_id => group_id  
)

Resource.create(
  :text => '<a href="http://www.iom.edu/~/media/Files/Report%20Files/2011/Breast-Cancer-Environment/BreastCancerReportbrief_2.pdf">Institute of Medicine&mdash;Breast Cancer and the Environment: A Life Course Approach (PDF)</a>',
  :group_id => group_id  
)

Resource.create(
  :text => '<a href="http://www.iom.edu/~/media/Files/Report%20Files/2011/Breast-Cancer-Environment/IOM_breastcancer_QandA.pdf">Institute of Medicine&mdash;Breast Cancer and the Environment: Questions and Answers (PDF)</a>',
  :group_id => group_id  
)

Resource.create(
  :text => '<a href="http://www.cancer.gov/cancertopics/factsheet/Risk/obesity">National Cancer Institute&mdash;Obesity Fact Sheet</a>',
  :group_id => group_id  
)