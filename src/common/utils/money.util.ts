export const roundMoney = (value: unknown): number => {
  const numeric = Number(value ?? 0);

  if (!Number.isFinite(numeric)) {
    return 0;
  }

  return Math.round((numeric + Number.EPSILON) * 100) / 100;
};

export const sumMoney = (values: unknown[]): number =>
  roundMoney(values.reduce<number>((sum, value) => sum + roundMoney(value), 0));

export const calculatePercentageAmount = (
  baseAmount: unknown,
  percentage: unknown,
): number => roundMoney((roundMoney(baseAmount) * Number(percentage ?? 0)) / 100);

export const applyPercentageAdjustment = (
  baseAmount: unknown,
  percentage: unknown,
): number => roundMoney(roundMoney(baseAmount) * (1 + Number(percentage ?? 0) / 100));

export const calculateIncludedPercentageAmount = (
  grossAmount: unknown,
  percentage: unknown,
): { base: number; tax: number; total: number } => {
  const total = roundMoney(grossAmount);
  const rate = Number(percentage ?? 0);

  if (!Number.isFinite(rate) || rate <= 0) {
    return { base: total, tax: 0, total };
  }

  const base = roundMoney(total / (1 + rate / 100));
  return {
    base,
    tax: roundMoney(total - base),
    total,
  };
};