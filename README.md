# Golden MA MTF TT [x5]

## Overview
Golden MA MTF TT [x5] is a multi-timeframe indicator for MetaTrader 4 (MT4) that creates a system of dynamic support and resistance levels based on various price calculations. The indicator displays multiple levels including buy/sell zones, reversal points, overbought/oversold areas, and danger zones, all of which adapt to market conditions.

## Original Authors
- Original idea: GaoShan (kirc@yeah.net)
- Extended by: Tankk (tualatine@mail.ru)
- Original source: https://forexsystemsru.com/threads/indikatory-sobranie-sochinenij-tankk.86203/

## Features
- Multi-timeframe support
- Five different price calculation methods
- Customizable support and resistance levels
- Visual representation of previous day's high and low
- Clearly marked trading zones (buy/sell areas)
- Warning levels for overbought/oversold conditions
- Danger zones for trade stop levels
- Customizable colors, text size, and line styles

## Input Parameters

### Time and Price Settings
- **ПериодГрафика** (Chart Period): The timeframe used for calculations (default: PERIOD_D1)
- **ЦЕНА** (Price Method): Price calculation method (default: TYPICAL)
  - CO: (Close + Open) / 2
  - OCLH: (Open + Close + Low + High) / 4
  - MEDIAN: (High + Low) / 2
  - TYPICAL: (High + Low + Close) / 3
  - WEIGHTED: (High + Low + 2 * Close) / 4

### Level Settings
- **СтартПипсы** (Start Pips): Base distance in pips for the first level (default: 20)
- **ВнутрПипсы** (Inner Pips): Distance between inner levels in pips (default: 1)
- **ЗаГраницами** (Outside Boundaries): Show inner levels outside the main levels (default: false)
- **СколькоЧасовВправо** (Hours to the Right): How many hours to extend the levels to the right (default: 4)

### Visualization Settings
- **ЦветЦентр** (Center Color): Color for the middle line (default: DarkSlateBlue)
- **ЦветHI** (High Color): Color for resistance levels (default: MediumBlue)
- **ЦветLO** (Low Color): Color for support levels (default: MediumVioletRed)
- **РазмерЦентр** (Center Size): Line width for the middle line (default: 5)
- **РазмерHiLo** (HiLo Size): Line width for support and resistance levels (default: 4)

### Previous High/Low Settings
- **ВчерашнийHiLo** (Yesterday's High/Low): Show previous period's high and low (default: true)
- **вчерЦвет** (Yesterday Color): Color for previous high/low lines (default: Orange)
- **вчерРазмер** (Yesterday Size): Line width for previous high/low lines (default: 1)
- **вчерСтиль** (Yesterday Style): Line style for previous high/low lines (default: DOT)

### Text Settings
- **ТекстРазмер** (Text Size): Size of label text (default: 8)
- **МеткиСправа** (Labels on Right): Position labels on the right side (default: true)
- **ТекстЦвет** (Text Color): Color for text labels (default: White)
- **ШРИФТ** (Font): Font for text labels (default: "Verdana")

### Period Markers
- **НачалоКонецПериода** (Period Start/End): Show period start/end markers (default: true)

## Level Descriptions

The indicator creates multiple levels for trading guidance:

### Resistance Levels (From Middle to Top)
1. **HI1**: Buy Area Start
2. **HI2**: Buy Area End
3. **HI3**: Reversal High
4. **HI4**: Warning! Overbought
5. **HI5**: Danger! Stop Buy Here!

### Middle Level
- **MID**: Middle Area (base calculation point)

### Support Levels (From Middle to Bottom)
1. **LO1**: Sell Area Start
2. **LO2**: Sell Area End
3. **LO3**: Reversal Low
4. **LO4**: Warning! Oversold
5. **LO5**: Danger! Stop Sell Here!

## How It Works

The indicator calculates a middle price level (MID) based on the selected price method and the previous period's prices. From this middle level, it derives:

1. **Basic levels**: Simple pip-based distances from the middle level
2. **Complex levels**: Calculations that incorporate high, low, and middle values
3. **Inner levels**: Additional levels between the main levels for finer detail

All levels are drawn as horizontal lines extending from the current period start to a specified number of hours into the future.

## Installation
1. Copy the .mq4 file to your MetaTrader 4 indicators folder (usually located at C:\Program Files\MetaTrader 4\MQL4\Indicators)
2. Restart MetaTrader 4 or refresh the Navigator panel
3. Find "Golden MA MTF TT [x5]" in the Navigator panel under "Indicators"
4. Drag it onto your chart

## Usage Recommendations

### For Trend Trading
- Look for price action between the Middle level and HI1/LO1 levels to trade with the trend
- Use the Middle level as a dynamic pivot point
- Consider buying when price is between MID and HI1, selling when between MID and LO1

### For Reversal Trading
- Watch for price action near HI3/LO3 (Reversal levels) for potential reversals
- Use HI4/LO4 (Overbought/Oversold levels) as confirmation of extreme conditions
- Never trade beyond HI5/LO5 (Danger zones) in the respective direction

### For Range Trading
- Trade between HI1 and LO1 levels in sideways markets
- Use inner levels for more precise entry and exit points

## Notes
- The indicator works best on higher timeframes (H1, H4, D1)
- Adjust the "Start Pips" parameter based on the volatility of the instrument
- Previous period's high and low can serve as additional reference points
- The indicator is particularly useful for identifying potential reversal zones

## Disclaimer
This indicator is meant to be used as a tool to assist with trading decisions, not as an automatic trading system. Always use proper risk management and combine this indicator with other forms of analysis before making trading decisions.
