//+------------------------------------------------------------------+
//|                                                          zym.mqh |
//|                        Copyright 2017, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2017, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+
//| defines                                                          |
//+------------------------------------------------------------------+
// #define MacrosHello   "Hello, world!"
// #define MacrosYear    2010
//+------------------------------------------------------------------+
//| DLL imports                                                      |
//+------------------------------------------------------------------+
// #import "user32.dll"
//   int      SendMessageA(int hWnd,int Msg,int wParam,int lParam);
// #import "my_expert.dll"
//   int      ExpertRecalculate(int wParam,int lParam);
// #import
//+------------------------------------------------------------------+
//| EX5 imports                                                      |
//+------------------------------------------------------------------+
// #import "stdlib.ex5"
//   string ErrorDescription(int error_code);
// #import
//+------------------------------------------------------------------+
bool ClosePosition(int type){//Close all pending and holding positions
   
   bool Flag=true;
   int tick[10000],tp[10000];
   int j=0;
   for(int i=0;i<OrdersTotal();i++){
      OrderSelect(i, SELECT_BY_POS, MODE_TRADES);
      j=j+1;
      tick[j]=OrderTicket();
      tp[j]=OrderType();
   }
   if (j!=0){
      for(int i=1;i<=j;i++){
         OrderSelect(tick[i], SELECT_BY_TICKET);
         switch(tp[i]){
            case OP_BUY:
               if(type==OP_BUY){
                  if(OrderClose(tick[i],OrderLots(),Bid,3,CLR_NONE)==false) Flag=false;
               }
               CLOSE_flag = OP_BUY;
            break;
            case OP_SELL:
               if(type==OP_SELL){
                  if(OrderClose(tick[i],OrderLots(),Ask,3,CLR_NONE)==false) Flag=false;
               }
               CLOSE_flag = OP_SELL;
            break;
         }
      }
   }
   return(Flag);
}
double BUYProfit()
{
   double BuyProfit = 0;
   for (int t=0; t<OrdersTotal(); t++)
   {
      OrderSelect(t, SELECT_BY_POS, MODE_TRADES);
      if (OrderType() == OP_BUY)
      BuyProfit += OrderProfit();
   }
   return (BuyProfit);
}
double SELLProfit()
{
   double SellProfit = 0;
   for (int t=0; t<OrdersTotal(); t++)
   {
      OrderSelect(t, SELECT_BY_POS, MODE_TRADES);
      if (OrderType() == OP_SELL)
      SellProfit += OrderProfit();
   }
   return (SellProfit);
}
void printError(string msg,int id){
   if(id<0){
      Print(msg+"OrderSend 失败错误 #",GetLastError());
   }
}