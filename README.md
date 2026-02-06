# Replication & Extension: Deconstructing Monetary Policy Surprises (1994–2025)

This repository contains the code, data, and report for a replication and extension of **Jarociński and Karadi (2020)**: *"Deconstructing Monetary Policy Surprises - The Role of Information Shocks"*.

While the original study covers the period up to 2016, this project extends the analysis through **December 2025**, covering the post-pandemic era.

## Repository Contents

* **main.m**: Primary MATLAB script. Estimates the BVAR with options for Sign Restrictions (Panel A) or Standard HFI (Panel B).
* **data_monthly_clean.csv**: Dataset containing high-frequency surprises (Fed Funds Futures, S&P 500) and monthly macro variables updated to 2025.
* **Report.pdf**: Full research report detailing methodology and results.

## Methodology

We employ a **Bayesian Vector Autoregression (BVAR)** identified via **Sign Restrictions** to disentangle two shocks driving interest rates:
1.  **Pure Monetary Policy Shocks:** Rates rise, Stocks fall.
2.  **Central Bank Information Shocks:** Rates rise, Stocks rise.

## Key Results

* **Replication (1994–2016):** We successfully replicate the original findings. The standard identification (Cholesky) yields a "Price Puzzle" and insignificant financial friction responses, whereas our Sign Restriction approach recovers a logical transmission mechanism (falling prices, rising credit spreads).
* **Extension (2017–2025):** The identification strategy remains robust in the post-pandemic era. The "Information Channel" remains active, suggesting markets continue to extract private signals from FOMC announcements.

## Usage

To reproduce the Impulse Response Functions (IRFs):

1.  Open `main.m` in MATLAB.
2.  Adjust the `idscheme` variable:
    * Set `idscheme = 'sgnm2'` for the Sign Restriction model.
    * Set `idscheme = 'chol'` for the Standard HFI model.
3.  Run the script.

## Disclaimer

This project is an academic replication based on the work of **Marek Jarociński (ECB)** and **Peter Karadi (ECB)**.

**Original Paper:** Jarociński, M., & Karadi, P. (2020). *Deconstructing Monetary Policy Surprises*. American Economic Journal: Macroeconomics, 12(2).
[Link to Original Work](https://www.aeaweb.org/articles?id=10.1257/mac.20180090)
