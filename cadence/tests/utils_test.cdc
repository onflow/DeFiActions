import Test
import BlockchainHelpers

import "DeFiActionsMathUtils"

access(all) let protocolAccount = Test.getAccount(0x0000000000000007)

access(all)
fun setup() {
    var err = Test.deployContract(
        name: "DeFiActionsMathUtils",
        path: "../contracts/utils/DeFiActionsMathUtils.cdc",
        arguments: []
    )
    Test.expect(err, Test.beNil())
}

access(all)
fun testReducedPrecisionUInt256ToUFix64Succeeds() {
    let uintAmount: UInt256 = 24_244_814_054_591_000_000_000_000_000_000
    let ufixAmount: UFix64 = 24_244_814.05459100

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(uintAmount)
    Test.assertEqual(ufixAmount, actualUFixAmount)
}

access(all)
fun testReducedPrecisionUInt256SmallChangeToUFix64Succeeds() {
    let uintAmount: UInt256 = 24_244_814_000_020_000_000_000_000_000_000
    let ufixAmount: UFix64 = 24_244_814.000020

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(uintAmount)
    Test.assertEqual(ufixAmount, actualUFixAmount)
}

// Converting from UFix64 to UInt256 with reduced point precision (6 vs. 8) should round down
access(all)
fun testReducedPrecisionUFix64ToUInt256Succeeds() {
    let uintAmount: UInt256 = 24_244_814_054_591_540_000_000_000_000_000
    let ufixAmount: UFix64 = 24_244_814.05459154

    let actualUIntAmount = DeFiActionsMathUtils.toUInt256(ufixAmount)
    Test.assertEqual(uintAmount, actualUIntAmount)
}

access(all)
fun testDustUInt256ToUFix64Succeeds() {
    let dustUFixAmount: UFix64 = 0.00002547
    let dustUIntAmount: UInt256 = 25_470_000_000_000_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(dustUIntAmount)
    Test.assertEqual(dustUFixAmount, actualUFixAmount)
    Test.assert(actualUFixAmount > 0.0)
}

access(all)
fun testDustUFix64ToUInt256Succeeds() {
    let dustUFixAmount: UFix64 = 0.00002547
    let dustUIntAmount: UInt256 = 25_470_000_000_000_000_000

    let actualUIntAmount = DeFiActionsMathUtils.toUInt256(dustUFixAmount)
    Test.assertEqual(dustUIntAmount, actualUIntAmount)
    Test.assert(actualUIntAmount > 0)
}

access(all)
fun testZeroUInt256ToUFix64Succeeds() {
    let zeroUFixAmount: UFix64 = 0.0
    let zeroUIntAmount: UInt256 = 0

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(zeroUIntAmount)
    Test.assertEqual(zeroUFixAmount, actualUFixAmount)
}

access(all)
fun testZeroUFix64ToUInt256Succeeds() {
    let zeroUFixAmount: UFix64 = 0.0
    let zeroUIntAmount: UInt256 = 0

    let actualUIntAmount = DeFiActionsMathUtils.toUInt256(zeroUFixAmount)
    Test.assertEqual(zeroUIntAmount, actualUIntAmount)
}

access(all)
fun testNonFractionalUInt256ToUFix64Succeeds() {
    let nonFractionalUFixAmount: UFix64 = 100.0
    let nonFractionalUIntAmount: UInt256 = 100_000_000_000_000_000_000_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(nonFractionalUIntAmount)
    Test.assertEqual(nonFractionalUFixAmount, actualUFixAmount)
}

access(all)
fun testNonFractionalUFix64ToUInt256Succeeds() {
    let nonFractionalUFixAmount: UFix64 = 100.0
    let nonFractionalUIntAmount: UInt256 = 100_000_000_000_000_000_000_000_000

    let actualUIntAmount = DeFiActionsMathUtils.toUInt256(nonFractionalUFixAmount)
    Test.assertEqual(nonFractionalUIntAmount, actualUIntAmount)
}

access(all)
fun testLargeFractionalUInt256ToUFix64Succeeds() {
    let largeFractionalUFixAmount: UFix64 = 1.99785982
    let largeFractionalUIntAmount: UInt256 = 1_997_859_829_999_999_999_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(largeFractionalUIntAmount)
    Test.assertEqual(largeFractionalUFixAmount, actualUFixAmount)
}

access(all)
fun testLargeFractionalTrailingZerosUInt256ToUFix64Succeeds() {
    let largeFractionalUFixAmount: UFix64 = 1.99785982
    let largeFractionalUIntAmount: UInt256 = 1_997_859_829_999_000_000_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(largeFractionalUIntAmount)
    Test.assertEqual(largeFractionalUFixAmount, actualUFixAmount)
}

access(all)
fun testLargeFractionalUFix64ToUInt256Succeeds() {
    let largeFractionalUFixAmount: UFix64 = 1.99785982
    let largeFractionalUIntAmount: UInt256 = 1_997_859_820_000_000_000_000_000

    let actualUIntAmount = DeFiActionsMathUtils.toUInt256(largeFractionalUFixAmount)
    Test.assertEqual(largeFractionalUIntAmount, actualUIntAmount)
}

access(all)
fun testIntegerAndLeadingZeroFractionalUInt256ToUFix64Succeeds() {
    let ufixAmount: UFix64 = 100.00000500
    let uintAmount: UInt256 = 100_000_005_000_000_888_999_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(uintAmount)
    Test.assertEqual(ufixAmount, actualUFixAmount)
}

access(all)
fun testIntegerAndLeadingZeroFractionalUFix64ToUInt256Succeeds() {
    let ufixAmount: UFix64 = 100.00000500
    let uintAmount: UInt256 = 100_000_005_000_000_000_000_000_000

    let actualUIntAmount = DeFiActionsMathUtils.toUInt256(ufixAmount)
    Test.assertEqual(uintAmount, actualUIntAmount)
}

access(all)
fun testMaxUFix64ToUInt256Succeeds() {
    let ufixAmount: UFix64 = UFix64.max
    let uintAmount: UInt256 = 184_467_440_737_095_516_150_000_000_000_000_000

    let actualUIntAmount = DeFiActionsMathUtils.toUInt256(ufixAmount)

    Test.assertEqual(uintAmount, actualUIntAmount)
}

access(all)
fun testMaxUFix64AsUInt256ToUFix64Succeds() {
    let ufixAmount: UFix64 = UFix64.max
    var uintAmount: UInt256 = 184_467_440_737_095_516_150_000_000_000_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(uintAmount)

    Test.assertEqual(ufixAmount, actualUFixAmount)
}

/************************
* BALANCE CONVERSIONS *
************************/

access(all)
fun testUFix64ToUInt256BalanceBasicSucceeds() {
    let ufixAmount: UFix64 = 100.0
    let expectedUIntAmount: UInt256 = 100_000_000_000_000_000_000_000_000

    let actualUIntAmount = DeFiActionsMathUtils.toUInt256(ufixAmount)
    Test.assertEqual(expectedUIntAmount, actualUIntAmount)
}

access(all)
fun testUInt256BalanceToUFix64BasicSucceeds() {
    let ufixAmount: UFix64 = 100.0
    let uintAmount: UInt256 = 100_000_000_000_000_000_000_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(uintAmount)
    Test.assertEqual(ufixAmount, actualUFixAmount)
}

access(all)
fun testUFix64ToUInt256BalanceWithFractionalSucceeds() {
    let ufixAmount: UFix64 = 100.12345678
    let expectedUIntAmount: UInt256 = 100_123_456_780_000_000_000_000_000

    let actualUIntAmount = DeFiActionsMathUtils.toUInt256(ufixAmount)
    Test.assertEqual(expectedUIntAmount, actualUIntAmount)
}

access(all)
fun testUInt256BalanceToUFix64WithFractionalSucceeds() {
    let ufixAmount: UFix64 = 100.12345678
    let uintAmount: UInt256 = 100_123_456_780_000_000_000_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(uintAmount)
    Test.assertEqual(ufixAmount, actualUFixAmount)
}

access(all)
fun testUFix64ToUInt256BalanceZeroSucceeds() {
    let ufixAmount: UFix64 = 0.0
    let expectedUIntAmount: UInt256 = 0

    let actualUIntAmount = DeFiActionsMathUtils.toUInt256(ufixAmount)
    Test.assertEqual(expectedUIntAmount, actualUIntAmount)
}

access(all)
fun testUInt256BalanceToUFix64ZeroSucceeds() {
    let ufixAmount: UFix64 = 0.0
    let uintAmount: UInt256 = 0

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(uintAmount)
    Test.assertEqual(ufixAmount, actualUFixAmount)
}

access(all)
fun testUFix64ToUInt256BalanceSmallAmountSucceeds() {
    let ufixAmount: UFix64 = 0.00000001
    let expectedUIntAmount: UInt256 = 10_000_000_000_000_000

    let actualUIntAmount = DeFiActionsMathUtils.toUInt256(ufixAmount)
    Test.assertEqual(expectedUIntAmount, actualUIntAmount)
}

access(all)
fun testUInt256BalanceToUFix64SmallAmountSucceeds() {
    let ufixAmount: UFix64 = 0.00000001
    let uintAmount: UInt256 = 10_000_000_000_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(uintAmount)
    Test.assertEqual(ufixAmount, actualUFixAmount)
}

access(all)
fun testUFix64ToUInt256BalanceLargeAmountSucceeds() {
    let ufixAmount: UFix64 = 1_000_000.0
    let expectedUIntAmount: UInt256 = 1_000_000_000_000_000_000_000_000_000_000

    let actualUIntAmount = DeFiActionsMathUtils.toUInt256(ufixAmount)
    Test.assertEqual(expectedUIntAmount, actualUIntAmount)
}

access(all)
fun testUInt256BalanceToUFix64LargeAmountSucceeds() {
    let ufixAmount: UFix64 = 1_000_000.0
    let uintAmount: UInt256 = 1_000_000_000_000_000_000_000_000_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(uintAmount)
    Test.assertEqual(ufixAmount, actualUFixAmount)
}

access(all)
fun testUFix64ToUInt256BalancePrecisionLossSucceeds() {
    // Test that precision loss is handled correctly (16 decimals vs 8 decimals in UFix64)
    let ufixAmount: UFix64 = 1.12345678
    // Expected: precision loss in the last 8 digits, should round down
    let expectedUIntAmount: UInt256 = 1_123_456_780_000_000_000_000_000

    let actualUIntAmount = DeFiActionsMathUtils.toUInt256(ufixAmount)
    Test.assertEqual(expectedUIntAmount, actualUIntAmount)
}

access(all)
fun testUInt256BalanceToUFix64PrecisionLossSucceeds() {
    // Test that precision loss is handled correctly when converting back
    let ufixAmount: UFix64 = 1.12345678
    // separate uintAmount with underscores to avoid confusion
    let uintAmount: UInt256 = 1_123_456_780_000_000_000_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(uintAmount)
    Test.assertEqual(ufixAmount, actualUFixAmount)
}

access(all)
fun testUInt256BalanceToUFix64PrecisionLossTrimSucceeds() {
    // Test that precision loss is handled correctly when converting back
    let ufixAmount: UFix64 = 1.12345678
    // separate uintAmount with underscores to avoid confusion
    let uintAmount: UInt256 = 1_123_456_789_999_999_999_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64RoundDown(uintAmount)
    Test.assertEqual(ufixAmount, actualUFixAmount)
}

access(all)
fun testUInt256ToUFix64RoundDownSucceeds() {
    // Test that precision loss is handled correctly when converting back
    let ufixAmount: UFix64 = 1.12345678
    // separate uintAmount with underscores to avoid confusion
    let uintAmount: UInt256 = 1_123_456_784_444_444_444_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64Round(uintAmount)
    Test.assertEqual(ufixAmount, actualUFixAmount)
}

access(all)
fun testUInt256ToUFix64RoundUpSucceeds() {
    // Test that precision loss is handled correctly when converting back
    let ufixAmount: UFix64 = 1.12345679
    // separate uintAmount with underscores to avoid confusion
    let uintAmount: UInt256 = 1_123_456_789_999_999_999_000_000

    let actualUFixAmount = DeFiActionsMathUtils.toUFix64Round(uintAmount)
    Test.assertEqual(ufixAmount, actualUFixAmount)
}

access(all)
fun testBalanceConversionRoundTripSucceeds() {
    // Test round-trip conversion maintains precision
    let originalUFix: UFix64 = 123.45678901

    let toUInt = DeFiActionsMathUtils.toUInt256(originalUFix)
    let backToUFix = DeFiActionsMathUtils.toUFix64RoundDown(toUInt)

    Test.assertEqual(originalUFix, backToUFix)
}

access(all)
fun testBalanceConversionRoundTripWithZeroSucceeds() {
    // Test round-trip conversion with zero
    let originalUFix: UFix64 = 0.0

    let toUInt = DeFiActionsMathUtils.toUInt256(originalUFix)
    let backToUFix = DeFiActionsMathUtils.toUFix64RoundDown(toUInt)

    Test.assertEqual(originalUFix, backToUFix)
}

access(all)
fun testBalanceConversionRoundTripWithLargeNumberSucceeds() {
    // Test round-trip conversion with large number
    let originalUFix: UFix64 = 999_999.99999999

    let toUInt = DeFiActionsMathUtils.toUInt256(originalUFix)
    let backToUFix = DeFiActionsMathUtils.toUFix64RoundDown(toUInt)

    Test.assertEqual(originalUFix, backToUFix)
}

/***********************
* FIXED POINT MATH   *
***********************/

// Constants tests
access(all)
fun testConstantsAreCorrect() {
    // Test that e18 equals 10^18
    let expectedE24: UInt256 = 1_000_000_000_000_000_000_000_000
    Test.assertEqual(expectedE24, DeFiActionsMathUtils.e24)

    // Test that e9 equals 10^9
    let expectedE8: UInt256 = 100_000_000
    Test.assertEqual(expectedE8, DeFiActionsMathUtils.e8)
}

// mul() tests - multiplies two 18-decimal fixed-point numbers
access(all)
fun testMulBasicSucceeds() {
    // 2.0 * 3.0 = 6.0
    let x: UInt256 = 2 * DeFiActionsMathUtils.e24  // 2.0 in 24-decimal
    let y: UInt256 = 3 * DeFiActionsMathUtils.e24  // 3.0 in 24-decimal
    let expected: UInt256 = 6 * DeFiActionsMathUtils.e24  // 6.0 in 24-decimal

    let result = DeFiActionsMathUtils.mul(x, y)
    Test.assertEqual(expected, result)
}

access(all)
fun testMulFractionalSucceeds() {
    // 1.5 * 2.25 = 3.375
    let x: UInt256 = 1_500_000_000_000_000_000_000_000  // 1.5 in 24-decimal
    let y: UInt256 = 2_250_000_000_000_000_000_000_000  // 2.25 in 24-decimal
    let expected: UInt256 = 3_375_000_000_000_000_000_000_000  // 3.375 in 24-decimal

    let result = DeFiActionsMathUtils.mul(x, y)
    Test.assertEqual(expected, result)
}

access(all)
fun testMulWithZeroSucceeds() {
    // 5.0 * 0.0 = 0.0
    let x: UInt256 = 5 * DeFiActionsMathUtils.e24
    let y: UInt256 = 0
    let expected: UInt256 = 0

    let result = DeFiActionsMathUtils.mul(x, y)
    Test.assertEqual(expected, result)
}

access(all)
fun testMulWithOneSucceeds() {
    // 5.0 * 1.0 = 5.0
    let x: UInt256 = 5 * DeFiActionsMathUtils.e24
    let y: UInt256 = DeFiActionsMathUtils.e24  // 1.0
    let expected: UInt256 = 5 * DeFiActionsMathUtils.e24

    let result = DeFiActionsMathUtils.mul(x, y)
    Test.assertEqual(expected, result)
}

access(all)
fun testMulSmallNumbersSucceeds() {
    // 0.001 * 0.002 = 0.000002
    let x: UInt256 = 1_000_000_000_000_000_000_000  // 0.001 in 24-decimal
    let y: UInt256 = 2_000_000_000_000_000_000_000  // 0.002 in 24-decimal
    let expected: UInt256 = 2_000_000_000_000_000_000  // 0.000002 in 24-decimal

    let result = DeFiActionsMathUtils.mul(x, y)
    Test.assertEqual(expected, result)
}

access(all)
fun testMulLargeNumbersSucceeds() {
    // 1000.0 * 2000.0 = 2000000.0
    let x: UInt256 = 1000 * DeFiActionsMathUtils.e24
    let y: UInt256 = 2000 * DeFiActionsMathUtils.e24
    let expected: UInt256 = 2000000 * DeFiActionsMathUtils.e24

    let result = DeFiActionsMathUtils.mul(x, y)
    Test.assertEqual(expected, result)
}

// div() tests - divides two 18-decimal fixed-point numbers
access(all)
fun testDivBasicSucceeds() {
    // 6.0 / 2.0 = 3.0
    let x: UInt256 = 6 * DeFiActionsMathUtils.e24
    let y: UInt256 = 2 * DeFiActionsMathUtils.e24
    let expected: UInt256 = 3 * DeFiActionsMathUtils.e24

    let result = DeFiActionsMathUtils.div(x, y)
    Test.assertEqual(expected, result)
}

access(all)
fun testDivFractionalSucceeds() {
    // 3.375 / 1.5 = 2.25
    let x: UInt256 = 3_375_000_000_000_000_000_000_000  // 3.375 in 24-decimal
    let y: UInt256 = 1_500_000_000_000_000_000_000_000  // 1.5 in 24-decimal
    let expected: UInt256 = 2_250_000_000_000_000_000_000_000  // 2.25 in 24-decimal

    let result = DeFiActionsMathUtils.div(x, y)
    Test.assertEqual(expected, result)
}

access(all)
fun testDivWithOneSucceeds() {
    // 5.0 / 1.0 = 5.0
    let x: UInt256 = 5 * DeFiActionsMathUtils.e24
    let y: UInt256 = DeFiActionsMathUtils.e24  // 1.0
    let expected: UInt256 = 5 * DeFiActionsMathUtils.e24

    let result = DeFiActionsMathUtils.div(x, y)
    Test.assertEqual(expected, result)
}

access(all)
fun testDivZeroNumeratorSucceeds() {
    // 0.0 / 5.0 = 0.0
    let x: UInt256 = 0
    let y: UInt256 = 5 * DeFiActionsMathUtils.e24
    let expected: UInt256 = 0

    let result = DeFiActionsMathUtils.div(x, y)
    Test.assertEqual(expected, result)
}

access(all)
fun testDivPrecisionSucceeds() {
    // 1.0 / 3.0 = 0.333333333333333333 (truncated)
    let x: UInt256 = DeFiActionsMathUtils.e24
    let y: UInt256 = 3 * DeFiActionsMathUtils.e24
    let expected: UInt256 = 333_333_333_333_333_333_333_333  // Truncated result

    let result = DeFiActionsMathUtils.div(x, y)
    Test.assertEqual(expected, result)
}

// Round-trip and integration tests
access(all)
fun testMulDivRoundTripSucceeds() {
    // Test that mul and div are inverse operations
    let original: UInt256 = 123_456_789_012_345_678_900_000_000  // 123.4567890123456789 in 24-decimal
    let factor: UInt256 = 3 * DeFiActionsMathUtils.e24  // 3.0

    let multiplied = DeFiActionsMathUtils.mul(original, factor)
    let divided = DeFiActionsMathUtils.div(multiplied, factor)

    Test.assertEqual(original, divided)
}


access(all)
fun testFixedPointPrecisionConsistencySucceeds() {
    // Test that calculations maintain 18-decimal precision
    let price: UInt256 = 1_500_000_000_000_000_000_000_000  // $1.50 in 24-decimal
    let amount: UInt256 = 2_333_333_333_333_333_333_333_333  // 2.333333333333333333 tokens

    let totalValue = DeFiActionsMathUtils.mul(price, amount)
    let expectedValue: UInt256 = 3_499_999_999_999_999_999_999_999  // $3.499999999999999999

    Test.assertEqual(expectedValue, totalValue)
}

access(all)
fun testComplexCalculationSucceeds() {
    // Test a more complex calculation: (a * b) / (c + d)
    let a: UInt256 = 1_250_000_000_000_000_000_000_000  // 1.25
    let b: UInt256 = 3_200_000_000_000_000_000_000_000  // 3.2
    let c: UInt256 = 2_000_000_000_000_000_000_000_000  // 2.0
    let d: UInt256 = 1_500_000_000_000_000_000_000_000  // 1.5

    let numerator = DeFiActionsMathUtils.mul(a, b)  // 1.25 * 3.2 = 4.0
    let denominator = c + d  // 2.0 + 1.5 = 3.5 (addition doesn't need scaling)
    let result = DeFiActionsMathUtils.div(numerator, denominator)  // 4.0 / 3.5 ≈ 1.(142857)...

    let expected: UInt256 = 1_142_857_142_857_142_857_142_857  // Truncated result
    Test.assertEqual(expected, result)
}

access(all)
fun testPercentageCalculationSucceeds() {
    // Test percentage calculation: 15% of 1000.0
    let amount: UInt256 = 1_000 * DeFiActionsMathUtils.e24  // 1000.0
    let percentage: UInt256 = 150_000_000_000_000_000_000_000  // 0.15 (15%)

    let result = DeFiActionsMathUtils.mul(amount, percentage)
    let expected: UInt256 = 150 * DeFiActionsMathUtils.e24  // 150.0

    Test.assertEqual(expected, result)
}

access(all)
fun testInterestRateCalculationSucceeds() {
    // Test interest calculation: principal * (1 + rate)
    let principal: UInt256 = 1_000 * DeFiActionsMathUtils.e24  // 1000.0
    let rate: UInt256 = 50_000_000_000_000_000_000_000  // 0.05 (5%)
    let one: UInt256 = DeFiActionsMathUtils.e24  // 1.0

    let onePlusRate = one + rate  // 1.05
    let result = DeFiActionsMathUtils.mul(principal, onePlusRate)
    let expected: UInt256 = 1_050 * DeFiActionsMathUtils.e24  // 1050.0

    Test.assertEqual(expected, result)
}

access(all)
fun testDivWithRoundingSucceeds() {
    // Test interest calculation: principal * (1 + rate)
    let dividend  = 10.0
    let divisor = 11.0

    let result = DeFiActionsMathUtils.divWithRounding(dividend, divisor)
    let expected = 0.90909091

    Test.assertEqual(expected, result)
}
