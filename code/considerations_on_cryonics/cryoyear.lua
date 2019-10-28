--curent age of the user of this script
curage=20

--value of one year of life
val_year=50000

--probability of cryonics success
prob_succ=0.05

--years gained by cryonics
years_gain=4500

--probability of being preserved
prob_pres=0.6

--starting value for probability for signing up to cryo, exponentially decreasing
decay=1

--CMS cost
cms=180

--Cost of preservation/life insurance
preservation_cost=90000

actval={78.36, 78.64, 78.66, 78.67, 78.68, 78.69, 78.69, 78.70, 78.71, 78.71, 78.72, 78.72, 78.73, 78.73, 78.74, 78.75, 78.75, 78.77, 78.79, 78.81, 78.83, 78.86, 78.88, 78.91, 78.93, 78.96, 78.98, 79.01, 79.03, 79.06, 79.09, 79.12, 79.15, 79.18, 79.21, 79.25, 79.29, 79.32, 79.37, 79.41, 79.45, 79.50, 79.55, 79.61, 79.66, 79.73, 79.80, 79.87, 79.95, 80.03, 80.13, 80.23, 80.34, 80.46, 80.59, 80.73, 80.88, 81.05, 81.22, 81.42, 81.62, 81.83, 82.05, 82.29, 82.54, 82.80, 83.07, 83.35, 83.64, 83.94, 84.25, 84.57, 84.89, 85.23, 85.58, 85.93, 86.30, 86.68, 87.08, 87.49, 87.92, 88.38, 88.86, 89.38, 89.91, 90.47, 91.07, 91.69, 92.34, 93.01, 93.70, 94.42, 95.16, 95.94, 96.72, 97.55, 98.40, 99.27, 100.14, 101.02, 101.91}

--probability of still signing up for cryonics at a given age

function prob_signup(age)
	return decay^(age-curage)
end

b=0.108
eta=0.0001

function gompertz(age)
	return math.exp(-eta*(math.exp(b*age)-1))
end

function prob_liveto(age)
	return gompertz(age)/gompertz(curage)
end

function benefit(age)
	return prob_pres*prob_succ*years_gain*val_year
end

function cms_age(age)
	return actval[age]-10
end

function cms_fees(age)
	return cms*(actval[age]-cms_age(age))
end

function membership_fees(age)
	local left=math.floor(actval[age])-age
	local cost=0

	if age<25 then
		newage=25
		cost=(newage-age)*310
	end
	if left>=30 then
		cost=cost+(left-30)*305
		left=30
	end
	if left>=25 then
		cost=cost+(left-25)*368
		left=24
	end
	if left>=20 then
		cost=cost+(left-20)*430
		left=20
	end
	if age<=25 then
		cost=cost+(left-(25-age))*525
	else
		cost=cost+left*525
	end

	return 300+cost
end

function pres_cost(age)
	return preservation_cost
end

function cost(age)
	return membership_fees(age)+pres_cost(age)+cms_fees(age)
end

function value(age)
	return prob_signup(age)*prob_liveto(age)*(benefit(age)-cost(age))
end

for age=curage,math.floor(actval[curage]) do
	print(value(age) .. ": " .. age)
end
