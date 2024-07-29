import numpy as np

# Seed for reproducibility
np.random.seed(0)

# Parameters
num_simulations = 1000  # Number of simulations
present_value_min = 5000
present_value_max = 999000
interest_rates = np.array([0.05, 0.10, 0.15])
years = np.array([1, 5, 10])

# Generate random present values, interest rates, and years
random_present_values = np.random.uniform(present_value_min, present_value_max, num_simulations)
random_interest_rates = np.random.choice(interest_rates, num_simulations)
random_years = np.random.choice(years, num_simulations)

# Calculate end values
end_values = random_present_values * (1 + random_interest_rates) ** random_years

# Print statistics
print(f"Mean End Value: ${np.mean(end_values):,.2f}")
print(f"Median End Value: ${np.median(end_values):,.2f}")
print(f"Standard Deviation of End Value: ${np.std(end_values):,.2f}")

# Optional: Print some sample data
sample_indices = np.random.choice(num_simulations, 10, replace=False)
for i in sample_indices:
    print(f"Account {i + 1}:")
    print(f"  Present Value: ${random_present_values[i]:,.2f}")
    print(f"  Interest Rate: {random_interest_rates[i] * 100:.2f}%")
    print(f"  Time (Years): {random_years[i]}")
    print(f"  End Value: ${end_values[i]:,.2f}")
    print()

# Optionally, visualize the results using matplotlib
import matplotlib.pyplot as plt

plt.hist(end_values, bins=50, edgecolor='k', alpha=0.7)
plt.title('Distribution of End Values')
plt.xlabel('End Value')
plt.ylabel('Frequency')
plt.show()
