//+------------------------------------------------------------------+
//|                                                          BBI.mq4 |
//|                                             Copyright 2010, trad |
//|                                            du_steven@hotmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2010, trad"
#property link      "du_steven@hotmail.com"

#property indicator_chart_window
#property indicator_buffers 1
#property indicator_color1 White

//---- input parameters
extern int       Period1 = 3;
extern int       Period2 = 6;
extern int       Period3 = 12;
extern int       Period4 = 24;

double BBIBuffer[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
   IndicatorBuffers(1);
   //---- indicator line
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,BBIBuffer);

   string short_name="BBI("+Period1+","+Period2+","+Period3+","+Period4+")";
   IndicatorShortName(short_name);
   SetIndexLabel(0,short_name);
   //----
   SetIndexDrawBegin(0,Period4+1);
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   int i, counted_bars=IndicatorCounted();
   double ma1, ma2, ma3, ma4;
//----
   if(Bars<=Period4) return(0);
   
   if(counted_bars<1)
      for(i=1;i<=Period4;i++) BBIBuffer[Bars-i]=EMPTY_VALUE;
      
   if(counted_bars>0) counted_bars--;
   int limit=Bars-counted_bars;
   for(i=0; i<limit; i++)
   {
      ma1=iMA(Symbol(),0,Period1,0,MODE_SMA,PRICE_CLOSE, i);      
      ma2=iMA(Symbol(),0,Period2,0,MODE_SMA,PRICE_CLOSE, i);      
      ma3=iMA(Symbol(),0,Period3,0,MODE_SMA,PRICE_CLOSE, i);      
      ma4=iMA(Symbol(),0,Period4,0,MODE_SMA,PRICE_CLOSE, i);      
      
      BBIBuffer[i] = (ma1+ma2+ma3+ma4)/4; 
   }
   //----
   return(0);
}
//+------------------------------------------------------------------+