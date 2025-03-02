//+++======================================================================+++
//+++                        Golden MA MTF TT [x5]                         +++
//+++======================================================================+++
#property copyright   "©  GaoShan  &&&&  Tankk,  8  июля  2017,  http://forexsystemsru.com/" 
#property link        "https://forexsystemsru.com/threads/indikatory-sobranie-sochinenij-tankk.86203/"  ////https://forexsystemsru.com/forums/indikatory-foreks.41/
//------
#property description "Оригинальная идея:  GaoShan  @   kirc@yeah.net"
#property description " "
#property description "расширил настройки  :-))" 
#property description " "
#property description "Почта:  tualatine@mail.ru" 
//#property version "2.52"  //из "4.0"
//#property strict
#property indicator_chart_window
#property indicator_buffers 0
//+++======================================================================+++
//+++                   Custom indicator ENUM settings                     +++
//+++======================================================================+++
enum calcPR { CO, OCLH, MEDIAN, TYPICAL, WEIGHTED };
//+++======================================================================+++
//+++                 Custom indicator input parameters                    +++
//+++======================================================================+++

extern ENUM_TIMEFRAMES ПериодГрафика  =  PERIOD_D1;
extern calcPR                   ЦЕНА  =  TYPICAL;
extern int                СтартПипсы  =  20;
extern int                ВнутрПипсы  =  1;
extern bool              ЗаГраницами  =  false;
extern int        СколькоЧасовВправо  =  4;  //12;
extern color               ЦветЦентр  =  clrDarkSlateBlue,  //LightSteelBlue,
                              ЦветHI  =  clrMediumBlue,
                              ЦветLO  =  clrMediumVioletRed;   //Brown;
extern int               РазмерЦентр  =  5,
                          РазмерHiLo  =  4;

extern bool            ВчерашнийHiLo  =  true;
extern color                вчерЦвет  =  clrOrange;
extern int                вчерРазмер  =  1;
extern ENUM_LINE_STYLE     вчерСтиль  =  STYLE_DOT;

extern int               ТекстРазмер  =  8;
extern bool              МеткиСправа  =  true;
extern color               ТекстЦвет  =  clrWhite;
string                         ШРИФТ  =  "Verdana";   //"Arial";

extern bool       НачалоКонецПериода  =  true;

//+++======================================================================+++
//+++                     Custom indicator buffers                         +++
//+++======================================================================+++
double HIGH, LOW, OPEN, CLOSE, MID;
double HI1, HI2, HI3, HI4, HI5;
double LO1, LO2, LO3, LO4, LO5;    int stPIP, inPIP;
double POINT;   datetime LastBarOpenTime;  string PREF;
//+++======================================================================+++
//+++              Custom indicator initialization function                +++
//+++======================================================================+++
int init() 
{
   ПериодГрафика = fmax(ПериодГрафика,_Period);    
   stPIP = СтартПипсы;   if (СтартПипсы<0) stPIP = 1;
   inPIP = ВнутрПипсы;   if (ВнутрПипсы<0) inPIP = 0;
   POINT = _Point;  if (Digits==3 || Digits==5) POINT*=10;
//------
   PREF = stringMTF(ПериодГрафика)+": GoldMA TT ["+ (string)ЦЕНА+"*"+(string)СтартПипсы+"+"+(string)ВнутрПипсы+">"+(string)СколькоЧасовВправо+"]";
//------
return (0);
}
//+++======================================================================+++
//+++              Custom indicator deinitialization function              +++
//+++======================================================================+++
int deinit()  { ALL_OBJ_DELETE();  return(0); }
   //ObjectsDeleteAll(0, OBJ_TREND);
   //ObjectsDeleteAll(0, OBJ_TEXT);
//+++======================================================================+++
void ALL_OBJ_DELETE()
{
   string name;
   for (int s=ObjectsTotal()-1; s>=0; s--) {
        name=ObjectName(s);
        if (StringSubstr(name,0,StringLen(PREF))==PREF) ObjectDelete(name); }  
}
//+++======================================================================+++
bool NewBarTF(int period) 
{
   datetime BarOpenTime=iTime(NULL,period,0);
   if (BarOpenTime!=LastBarOpenTime) {
       LastBarOpenTime=BarOpenTime;
       return (true); } 
   else 
       return (false);
}
//+++======================================================================+++
//+++                 Custom indicator iteration function                  +++
//+++======================================================================+++
int start() 
{
   if (NewBarTF(ПериодГрафика)) ALL_OBJ_DELETE();  //PERIOD_D1
//------
   HIGH  = iHigh(NULL, ПериодГрафика, 1);   //PERIOD_D1
   LOW   = iLow(NULL, ПериодГрафика, 1);
   OPEN  = iOpen(NULL, ПериодГрафика, 1);
   CLOSE = iClose(NULL, ПериодГрафика, 1);
//------   //// enum calcPR { CO, OCLH, MEDIAN, TYPICAL, WEIGHTED };
   if (ЦЕНА==0) MID = NormalizeDouble((CLOSE + OPEN) / 2, Digits);
   if (ЦЕНА==1) MID = NormalizeDouble((OPEN + CLOSE + LOW + HIGH) / 4, Digits);
   if (ЦЕНА==2) MID = NormalizeDouble((HIGH + LOW) / 2, Digits);
   if (ЦЕНА==3) MID = NormalizeDouble((HIGH + LOW + CLOSE) / 3, Digits);
   if (ЦЕНА==4) MID = NormalizeDouble((HIGH + LOW + 2 * CLOSE) / 4, Digits);
//------
   HI1 = NormalizeDouble(MID + stPIP * POINT, Digits);
   HI2 = NormalizeDouble(MID + 2 * stPIP * POINT, Digits);
   HI3 = NormalizeDouble(HI1 + MID - LOW - 5 * POINT, Digits);
   HI4 = NormalizeDouble(MID + (HIGH - LOW) + 5 * POINT, Digits);
   HI5 = NormalizeDouble(2 * MID + (HIGH - 2 * LOW) + 5 * POINT, Digits);
//------
   LO1 = NormalizeDouble(MID - stPIP * POINT, Digits);
   LO2 = NormalizeDouble(MID - 2 * stPIP * POINT, Digits);
   LO3 = NormalizeDouble(LO1 + MID - HIGH + 5 * POINT, Digits);
   LO4 = NormalizeDouble(MID - (HIGH - LOW) - 5 * POINT, Digits);
   LO5 = NormalizeDouble(2 * MID - (2 * HIGH - LOW) - 5 * POINT, Digits);
//------
   datetime timeD0 = iTime(NULL, ПериодГрафика, 0);
   datetime timeD1 = iTime(NULL, ПериодГрафика, 1);
   datetime timeCUR = iTime(NULL, 0, 0) + 3600*СколькоЧасовВправо;
//------
   if (ВчерашнийHiLo) {
       creatTrendLineObj2("_YHI", timeD1, HIGH, timeCUR, HIGH, вчерЦвет, вчерРазмер, вчерСтиль);
       creatTrendLineObj2("_YLO", timeD1, LOW, timeCUR, LOW, вчерЦвет, вчерРазмер, вчерСтиль);
   //------
       if (ТекстРазмер>4) {
           datetime precur = timeD1;   if (МеткиСправа) precur = timeD0;
           createTextObj("_YHI_tx", precur, HIGH, StringConcatenate("[Previous High]: ", HIGH));  //Yesterday
           createTextObj("_YLO_tx", precur, LOW, StringConcatenate("[Previous Low]: ", LOW)); } }  //Yesterday
//------
   if (НачалоКонецПериода) {
       creatTrendLineObj2("_YStrt", timeD1, WindowPriceMin()-10*POINT, timeD1, WindowPriceMax()+10*POINT, DarkGray, 1, STYLE_DOT);
       creatTrendLineObj2("_YEnd", timeD0, WindowPriceMin()-10*POINT, timeD0, WindowPriceMax()+10*POINT, DarkGray, 1, STYLE_DOT);
       creatTrendLineObj2("_CEnd", timeD0+60*ПериодГрафика, WindowPriceMin()-10*POINT, timeD0+60*ПериодГрафика, WindowPriceMax()+10*POINT, DarkGray, 1, STYLE_DOT); }  //timeD0+3600*24
//------
   creatTrendLineObj("_HI5", timeD0, HI5, timeCUR, ЦветHI, РазмерHiLo);
   creatTrendLineObj("_HI4", timeD0, HI4, timeCUR, ЦветHI, РазмерHiLo);
   creatTrendLineObj("_HI3", timeD0, HI3, timeCUR, ЦветHI, РазмерHiLo);
   creatTrendLineObj("_HI2", timeD0, HI2, timeCUR, ЦветHI, РазмерHiLo);
   creatTrendLineObj("_HI1", timeD0, HI1, timeCUR, ЦветHI, РазмерHiLo);
//------
   creatTrendLineObj("_MID", timeD0, MID, timeCUR, ЦветЦентр, РазмерЦентр);  // центральная линия
//------
   creatTrendLineObj("_LO1", timeD0, LO1, timeCUR, ЦветLO, РазмерHiLo);
   creatTrendLineObj("_LO2", timeD0, LO2, timeCUR, ЦветLO, РазмерHiLo);
   creatTrendLineObj("_LO3", timeD0, LO3, timeCUR, ЦветLO, РазмерHiLo);
   creatTrendLineObj("_LO4", timeD0, LO4, timeCUR, ЦветLO, РазмерHiLo);
   creatTrendLineObj("_LO5", timeD0, LO5, timeCUR, ЦветLO, РазмерHiLo);
//------
   if (ТекстРазмер>4) 
    {
     precur = timeD0;   if (МеткиСправа) precur = timeCUR;
     createTextObj("_HI5_tx", precur, HI5, StringConcatenate("[DANGER! STOP BUY HERE!]: ", HI5));
     createTextObj("_HI4_tx", precur, HI4, StringConcatenate("[WARNING! OVERBOUGHT]: ", HI4));
     createTextObj("_HI3_tx", precur, HI3, StringConcatenate("[Reversal High]: ", HI3));
     createTextObj("_HI2_tx", precur, HI2, StringConcatenate("[Buy Area] End: ", HI2));
     createTextObj("_HI1_tx", precur, HI1, StringConcatenate("[Buy Area] Start: ", HI1));
   //------
     createTextObj("_MID_tx",  precur, MID, StringConcatenate("[Middle Area]: ", MID));
   //------
     createTextObj("_LO1_tx", precur, LO1, StringConcatenate("[Sell Area] Start: ", LO1));
     createTextObj("_LO2_tx", precur, LO2, StringConcatenate("[Sell Area] End: ", LO2));
     createTextObj("_LO3_tx", precur, LO3, StringConcatenate("[Reversal Low]: ", LO3));
     createTextObj("_LO4_tx", precur, LO4, StringConcatenate("[WARNING! OVERSOLD]: ", LO4));
     createTextObj("_LO5_tx", precur, LO5, StringConcatenate("[DANGER! STOP SELL HERE!]: ", LO5));
    }
//------
   if (ВнутрПипсы>0)
    {
     int PIPin = inPIP;   if (ЗаГраницами) PIPin = 1;
   //------
     for (int x=1; x<stPIP/PIPin; x++) 
      {
       creatTrendLineObj(StringConcatenate("_inHiHi", x),  timeD0, HI1 + x * inPIP * POINT, timeCUR, ЦветHI, 1);
       creatTrendLineObj(StringConcatenate("_inMidHi", x), timeD0, MID + x * inPIP * POINT, timeCUR, ЦветЦентр, 1);
       creatTrendLineObj(StringConcatenate("_inMidLo", x), timeD0, MID - x * inPIP * POINT, timeCUR, ЦветЦентр, 1);
       creatTrendLineObj(StringConcatenate("_inLoLo", x),  timeD0, LO1 - x * inPIP * POINT, timeCUR, ЦветLO, 1);
      }
    }
//------
//------
return (0);
}
//+++======================================================================+++
//+++                        Golden MA MTF TT [x5]                         +++
//+++======================================================================+++
void creatTrendLineObj(string Name, int TM1, double PR1, int TM2, color CLR, int SIZE) 
{
   ObjectDelete(PREF+Name);
   ObjectCreate(PREF+Name, OBJ_TREND, 0, TM1, PR1, TM2, PR1);
   ObjectSet(PREF+Name, OBJPROP_COLOR, CLR);
   ObjectSet(PREF+Name, OBJPROP_WIDTH, SIZE);
   ObjectSet(PREF+Name, OBJPROP_RAY, false);
   ObjectSet(PREF+Name, OBJPROP_BACK, true);
   ObjectSet(PREF+Name, OBJPROP_HIDDEN, true);
   ObjectSet(PREF+Name, OBJPROP_SELECTABLE, false);
}
//+++======================================================================+++
//+++                        Golden MA MTF TT [x5]                         +++
//+++======================================================================+++
void creatTrendLineObj2(string Name, int TM1, double PR1, int TM2, double PR2, color CLR, int SIZE, int STL) 
{
   ObjectDelete(PREF+Name);
   ObjectCreate(PREF+Name, OBJ_TREND, 0, TM1, PR1, TM2, PR2);
   ObjectSet(PREF+Name, OBJPROP_COLOR, CLR);
   ObjectSet(PREF+Name, OBJPROP_WIDTH, SIZE);
   ObjectSet(PREF+Name, OBJPROP_STYLE, STL);
   ObjectSet(PREF+Name, OBJPROP_RAY, false);
   ObjectSet(PREF+Name, OBJPROP_BACK, true);
   ObjectSet(PREF+Name, OBJPROP_HIDDEN, true);
   ObjectSet(PREF+Name, OBJPROP_SELECTABLE, false);
}
//+++======================================================================+++
//+++                        Golden MA MTF TT [x5]                         +++
//+++======================================================================+++
void createTextObj(string Name, int TM1, double PR1, string TEXT) 
{
   ObjectDelete(PREF+Name);
   ObjectCreate(PREF+Name, OBJ_TEXT, 0, TM1, PR1);
   ObjectSetText(PREF+Name, TEXT, ТекстРазмер, ШРИФТ, ТекстЦвет);
   ObjectSet(PREF+Name, OBJPROP_BACK, false);
   ObjectSet(PREF+Name, OBJPROP_HIDDEN, true);
   ObjectSet(PREF+Name, OBJPROP_SELECTABLE, false);
}
//+++======================================================================+++
//+++                        Golden MA MTF TT [x5]                         +++
//+++======================================================================+++
string stringMTF(int perMTF)
{  
   if (perMTF==0)     perMTF=_Period;
   if (perMTF==1)     return("M1");
   if (perMTF==5)     return("M5");
   if (perMTF==15)    return("M15");
   if (perMTF==30)    return("M30");
   if (perMTF==60)    return("H1");
   if (perMTF==240)   return("H4");
   if (perMTF==1440)  return("D1");
   if (perMTF==10080) return("W1");
   if (perMTF==43200) return("MN1");
   if (perMTF== 2 || 3  || 4  || 6  || 7  || 8  || 9 ||  /// нестандартные периоды для грфиков Renko
               10 || 11 || 12 || 13 || 14 || 16 || 17 || 18) return("M"+(string)_Period);
//------
   return("Period error!");
}
//+++======================================================================+++
//+++                        Golden MA MTF TT [x5]                         +++
//+++======================================================================+++
