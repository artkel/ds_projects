*##############################################################################
*                                Dateneingabe
*##############################################################################
$eolcom  //


*Deklaration of Sets and Parameter

Sets
         i       conventional technolgy
         n       nodes (countries)
                 /GER, NO/
         v       variable RES Technologies
                 /Wind, PV/
         t       time in hours         /1*8760/
         tfirst(t) subset of hours which identifies the first hour




;

alias (n,nn), (t,tt)
;

tfirst(t) = yes$(ord(t) eq 1)
;

Parameters
         vc(i)           variable production costs (€ per MWh)
         sc(i)           start up costs (€ per MWh)

         g_min(i)        minimum production level for each technology

         a(i)            availability factor conventiona technologies [%]
         a_reservoir     availability factor hydro reservoirs [%]
                         /0.8/
         a_PSP           availability factor pump storage [%]
                         /0.85/


         demand(t,n)     demand at each hour [MWh per h]
         wi(t,n)         wind production factor (MWh per MW)
         pvi(t,n)        PV production factor (MWh per MW)

         cap(i,n)        installed capacity for thermal and RoR technology i
         cap_RES(v,n)    capacity of variable RES

         cap_PSP(n)      Storage capacity [MW]
                         /GER    12000
                          No     0/
         inter_cap       Interconnector capacity [MW]
                         /3000/



         cap_Reservoir(n) capacity of Reservoirs [MWh]
                         /GER    0
                          No     135000000/
         power_reservoir(n)  turbine capacity for Reservoirs [MW]
                         /GER    0
                          NO     29000  /




;

Scalar
         eta_PSP          efficiency of storage power plants
                          /0.75/

         eta_Reservoir    efficiency of reservoir turbines
                         /0.92/
         capacity_power_factor   capacity power factor for pump storages
                         /9/

;

*1.Create Text File which includes the information where which parameter is to find
$onecho > ImportInfo.txt

Set=i       Rng=Technology!A3:A9 Cdim=0 Rdim=1

Par=a       Rng=Technology!N3:O9 Cdim=0 Rdim=1
Par=sc      Rng=Technology!E3:F9 Cdim=0 Rdim=1
Par=vc      Rng=Technology!H3:I9 Cdim=0 Rdim=1
Par=g_min   Rng=Technology!K3:L9 Cdim=0 Rdim=1

Par=demand  Rng=Demand!A1:C8761 Cdim=1 Rdim=1
Par=wi      Rng=Wind!A1:D8761 Cdim=1 Rdim=1
Par=pvi     Rng=PV!A1:D8761 Cdim=1 Rdim=1

Par=cap_RES Rng=RES!A2:C4 Cdim=1 Rdim=1
Par=cap     Rng=Technology!A2:C9 Cdim=1 Rdim=1

$offecho

*2.Convert Excel File to a .gdx file
$call GDXXRW I=Input_NordLink.xlsx O=Output.gdx @ImportInfo.txt

*3.Read the elements
$gdxin Output.gdx
$Load i
$Load a
$Load sc
$Load vc
$Load g_min
$Load demand
$Load wi
$Load pvi
$Load cap_RES
$Load cap

$gdxin
*Display data to see that everything is uploaded correctly
 Display i, a, sc, vc, g_min, demand, wi, pvi, cap_RES, cap_PSP, cap, eta_PSP
;

*$stop        //activate if you only want to stop the code here (for checking the data upload)
*##############################################################################
*                                MODEL FORMULATION
*#############################################################################
Variable

         COST    total cost of electricity production

;

Positive Variables
         GEN(n,i,t)        generation of technology i at time t
         RES_Gen(t,n)      generation by RES technologies

         P_ON(n,i,t)       online capacity of technology i at time t
         SU(n,i,t)         start up variable (can start up with any amount (not discrete))

         StorageLevel(t,n) charging level of PSP (upper lake)
         StLoad(t,n)       loading the PSP (pumping)
         StGen(t,n)        generation by PSP

         ReserLevel(t,n)   charging level of reservoirs
         ReGen(t,n)        generation by reservoirs
         Imp(t,n,nn)       Import to n from nn
         Exp(t,n,nn)       Export from n to nn






;

Equations
obj                      minimizing total costs
res_dem                  energy balance (supply=demand)
res_start                startup restriction (counter for SU)
res_max_online           online capacity lower than installed capacity
res_max_gen              maximum generation
res_min_gen              minimum generation
res_RES_Generation       defining the maximum hourly production by Wind and PV (includes curtailment option)

res_StorageLevel            PSP charging level
res_maximum_StorageLevel     maximum to which the PSP can be filled
res_maximum_storage          generation and pumping are limited to the turbine capacity
res_max_storage_generation   storage has to be charged to be able to produce


res_ReserLevel          level of reservoir at different time periods
res_ReservoirCap         reservoir capacity
res_maximum_reservoir   maximum generation of reservoir at any given time period
res_reservoirCap_first  1st period level definition

res_Imp              Import - Export Balance
res_Exp              Export-  Import Balance

res_im_ex               Import - Export




;

*******************      objecting function          ************************
obj..

                          COST =E= SUM((n,i,t), vc(i)*GEN(n,i,t) + sc(i)*SU(n,i,t));


*******************     market clearing condition          *******************
res_dem(t,n)..           demand(t,n) =E= SUM(i, GEN(n,i,t))
                                         + StGen(t,n)* eta_PSP - StLoad(t,n)
                                         + ReGen(t,n)* eta_Reservoir
                                         + RES_Gen(t,n)
                                         + sum(nn, Imp(t,n,nn)) - sum(nn, Exp(t,n,nn))           ;

res_im_ex(t,n,nn)..        Imp(t,n,nn)  =E=  Exp(t,nn,n)  ;



*Reservoir activity has to be added
*network flows have to be added

;

*****************    conventional power plant constraints    *******************
res_start(n,i,t)..                                                  //SU positive; therefore inequality
                         SU(n,i,t) =g= P_ON(n,i,t)-P_ON(n,i,t-1)
;
res_max_gen(n,i,t)..
                         GEN(n,i,t) =L= P_ON(n,i,t)
;
res_min_gen(n,i,t)..                                                //any MW online is a subject to MIN restriction
                         P_ON(n,i,t)*g_min(i) =L= GEN(n,i,t)
;
res_max_online(n,i,t)..
                         P_ON(n,i,t) =L= cap(i,n)*a(i)
;

*******************     RES Generation Constraints          *******************
res_RES_Generation(t,n)..
                    RES_Gen(t,n) =L= wi(t,n)*cap_RES('Wind',n) + pvi(t,n) *cap_RES('PV',n)
;

*******************       Storage activities          ************************
res_StorageLevel(t,n)..
                 StorageLevel(t+1,n) =E= StorageLevel(t,n)
                                 + StLoad(t,n) - StGen(t,n)
;
res_maximum_StorageLevel(t,n)..
                        StorageLevel(t,n) =L= cap_PSP(n)*capacity_power_factor
;
res_maximum_storage(t,n)..                                               //pump <-> turbine; you can use one way
                             StLoad(t,n) + StGen(t,n)  =L= CAP_PSP(n) * a_PSP
;
res_max_storage_generation(t,n)..                                       //i.e. something has to be inside to use
                           StGen(t,n)  =L= StorageLevel(t,n)
;

*******************       Reservoir activities          ************************
*Reservoir constraints have to be implemented
$ontext
res_ReserLevel(t,n)..
                            ReserLevel(t+1,n) =e= ReserLevel(t,n)  - ReGen(t,n) ;
res_maximum_ReserLevel(t,n)..
                            ReserLevel(t,n) =L=  cap_Reservoir(n)* a_reservoir ;

res_gener_reser(t,n)..
                           ReGen(t,n)   =L=  ReserLevel(t,n) ;

res_turbine_reser(t,n)..
                           ReGen(t,n)  =L=    power_reservoir(n)* a_reservoir;
$offtext

res_ReserLevel(t,n)$(ord(t) gt 2)..
                           ReserLevel(t,n) =e= ReserLevel(t-1,n) - ReGen(t,n) ;

res_reservoirCAP(t,n)..
                           ReGen(t,n)  =L=  ReserLevel(t,n) ;

res_maximum_reservoir(t,n)..
                           ReGen(t,n)  =L=  power_reservoir(n) * a_reservoir ;

res_reservoirCap_first (tfirst,n)..
                           ReserLevel(tfirst,n) =e= cap_Reservoir(n) ;


***********       Network defintions and restrictions       ********************
*transmission constraints have to be implemented

res_Imp(t,n,nn)..
                         Imp(t,n,nn) =L= inter_cap    ;
res_Exp(t,n,nn)..
                         Exp(t,n,nn) =L= inter_cap    ;



model NordLink
/
obj

res_dem
res_start
res_max_online
res_max_gen
res_min_gen
res_RES_Generation

res_StorageLevel
res_maximum_StorageLevel
res_maximum_storage
res_max_storage_generation

res_ReserLevel
res_ReservoirCap
res_maximum_reservoir
res_reservoirCap_first

res_Imp
res_Exp
res_im_ex
/
;

*##############################################################################
*                                Solving the Model
*##############################################################################

solve NordLink using LP minimizing COST
;

*##############################################################################
*                                Reporting
*##############################################################################
parameter
gener(*,n,i,t)           generation of each technology i at each time t
gener(*,nn,i,t)
import(*,n,nn,t)
export(*,n,nn,t)
price(*,t,n)
RES(*,t,n)
Storage_gen(*,t,n)
Reservoir_gen(*,t,n)
storage_load(*,t,n)

*add things you need

;

gener('bau',n,i,t)         = gen.L(n,i,t)             ;
gener('bau',nn,i,t)        = gen.L(nn,i,t)            ;
import('bau',n,nn,t)       = Imp.L(t,n,nn)            ;
export('bau',n,nn,t)       = Exp.L(t,n,nn)            ;
price('bau',t,n)           = res_dem.M(t,n)           ;
RES('bau',t,n)             = RES_Gen.L(t,n)           ;
Storage_gen('bau',t,n)     = StGen.L(t,n)             ;
Reservoir_gen('bau',t,n)   = ReGen.L(t,n)             ;
storage_load('bau',t,n)    = StLoad.L(t,n)            ;



display gener
;

*#################################  Excel Export  ###############################
*1. Create Text file which includes the information where which parameter is to put

$onecho > Exportinfo.txt
Par=gener                Rng=generation!A1       Cdim=1 Rdim=3
Par=gener                Rng=generation!A8       Cdim=1 Rdim=3
Par=import               Rng=powerflow!A1        Cdim=1 Rdim=3
Par=export               Rng=powerflow!A5        Cdim=1 Rdim=3
Par=price                Rng=price!A2            Cdim=1 Rdim=2
Par=RES                  Rng=RES!A5              Cdim=1 Rdim=2
Par=Storage_gen          Rng=storage_gen!A2      Cdim=1 Rdim=2
Par=Reservoir_gen        Rng=reservoir_gen!A2    Cdim=1 Rdim=2
Par=storage_load         Rng=storage_load!A2     Cdim=1 Rdim=2


$offecho
;

execute "XLSTALK -c Results_NordLink.xlsx"  ;
*closes the excel file automatically in case it is still opened

*2. Put the data in a .gdx file
execute_unload 'Results.gdx'
;
*3. Convert the .gdx file to an excel file
execute 'GDXXRW Results.gdx O=Results_NordLink.xlsx @Exportinfo.txt'
;

