I'm going to look at running gas vs a RCAC for heating your house. Lets go through all the values I'm using and why

* Gas Price 3c/MJ, this is a little above what I could get in my area
* Electricity Price 30c/kWh, this is a little below a good plan I can get
* Gas Efficiency 90%, this is a high efficiency for a gas heater, most older and cheaper units are more like 80%. The fan of the gas heater also uses about 300w when running.
* RCAC COP, my MHI Avanti Plus 2kw units are 5.74, but lets use 5, assuming yours are not quite as efficient
* Total heating load: 35kwh/day over 12 hours. This is roughly what my house uses looking at my historic data on an average day in the middle of winter.
* Split systems run all day, as they cycle up/down. Lets assume gas runs 25% of the time, as it cycles on/off
* Solar FIT of 5c/kWh

## Gas
Lets look at heating with gas, first we need to convert MJ of gas to kWh. We need 3.6 MJ of gas to get 1kwh of energy. So we can say the gas costs 10.8c/kWh. We are also assuming 90% gas efficiency, so to get 1kWh of heat output, its going to cost 12c. So to get the total heat output of 35kWh it would cost $4.20 of gas. But lets not forget the fan needs to run, over 12 hours, running 25% of the time thats 3 hours of the fan, at 300w, and 30c for electricity thats another 27c for the fan, so a total of $4.47 to heat the house for the day.

## RCAC
Now lets look at using RCAC, to get 35kwh of output, with a COP of 5 means we need to use 7kwh of electricity, at 30c thats a total cost of $2.10. Thats less than half the cost of gas!

## RCAC with Solar
Were not done yet though, many people have solar, so if you could run your RCAC off 100% solar, thats only $0.35 for the whole day! Gas does drop a little bit down to $4.25 because of the savings running the fan.

Running 100% from solar isn't really realistic though in winter, most people want the heating on early, and get limited solar.A more realistic number is 50% solar. This gives an effective cost of 17.5c/kWh, which gives a total cost of $1.23. Gas does again drop a little bit, down to $4.36

So in conclusion, we gave every advantage to gas we could, cheap gas, expensive electricity, low solar FIT, high gas efficiency, and low RCAC efficiency. Despite all that RCAC still only cost 28% the amount that gas cost.

## Calculator
Don't like the values I used, maybe the prices where you are are very different, heres a quick calculator, to fill in your numbers, and get your results.

<div id="calculator">
    <label>
    Gas Price (in cents)
        <input type="number" name="gas_price" 
        value=3
        onchange="calculateCosts()" />
    </label> <br />

    <label>
    Electricity Price (in cents)
        <input type="number" name="electricity_price" 
        value=30
        onchange="calculateCosts()"/>
    </label> <br />

    <label>
    Gas Efficiency (as a %)
        <input type="number" name="gas_efficiency" 
        value=90
        onchange="calculateCosts()"/>
    </label> <br />

    <label>
    Gas fan usage (in watts)
        <input type="number" name="gas_fan_usage" 
        value=300
        onchange="calculateCosts()"/>
    </label> <br />

    <label>
    RCAC COP
        <input type="number" name="cop" 
        value=5
        onchange="calculateCosts()"/>
    </label> <br />

    <label>
    Daily Heating Load (in kWh)
        <input type="number" name="daily_heating_load" 
        value=35
        onchange="calculateCosts()"/>
    </label> <br />

    <label>
    Run time (in hours)
        <input type="number" name="run_time" 
        value=12
        onchange="calculateCosts()"/>
    </label> <br />

    <label>
    What % of time is gas running
        <input type="number" name="gas_duty_cycle" 
        value=25
        onchange="calculateCosts()"/>
    </label> <br />

    <label>
    Solar FIT (in cents)
        <input type="number" name="solar_fit" 
        value=5
        onchange="calculateCosts()"/>
    </label> <br />
</div>

## Costs with 100% Grid
Gas: <span id="gas_100"></span>

RCAC <span id="rcac_100"></span>

## Costs with 50% Grid 50% Solar
Gas: <span id="gas_50"></span>

RCAC <span id="rcac_50"></span>

## Costs with 100% Solar
Gas: <span id="gas_0"></span>

RCAC <span id="rcac_0"></span>

<script type="text/javascript">
    function calculateCosts(){
        let gas_price = getValue("gas_price");
        let electricity_price = getValue("electricity_price");
        let gas_efficiency = getValue("gas_efficiency");
        let gas_fan_usage = getValue("gas_fan_usage");
        let cop = getValue("cop");
        let heating_load = getValue("daily_heating_load");
        let run_time = getValue("run_time");
        let gas_duty_cycle = getValue("gas_duty_cycle");
        let fit = getValue("solar_fit");

        let electricity_50 = (parseFloat(electricity_price) + parseFloat(fit)) / 2;

        setValue("gas_100", calculateGas(
            gas_price,
            gas_efficiency,
            gas_fan_usage,
            electricity_price,
            gas_duty_cycle,
            heating_load,
            run_time
        ));

        setValue("gas_50", calculateGas(
            gas_price,
            gas_efficiency,
            gas_fan_usage,
            electricity_50,
            gas_duty_cycle,
            heating_load,
            run_time
        ));

        setValue("gas_0", calculateGas(
            gas_price,
            gas_efficiency,
            gas_fan_usage,
            fit,
            gas_duty_cycle,
            heating_load,
            run_time
        ));

        setValue("rcac_100", calculateRcac(electricity_price, cop, heating_load));

        setValue("rcac_50", calculateRcac(electricity_50, cop, heating_load));

        setValue("rcac_0", calculateRcac(fit, cop, heating_load));
    }

    function getValue(name){
        return document.getElementsByName(name)[0].value
    }

    function setValue(name, value){
        document.getElementById(name).innerHTML = "$" + value.toFixed(2);
    }

    function calculateGas(
        gas_price,
        gas_efficiency,
        gas_fan_usage,
        electricity,
        gas_duty_cycle,
        heating_load,
        run_time
    ){
        let gas_cost = gas_price / 100 * 3.6 / (gas_efficiency / 100) * heating_load;

        let electricity_cost = electricity / 100 * gas_fan_usage / 1000 * run_time * gas_duty_cycle / 100;

        return gas_cost + electricity_cost;

    }

    function calculateRcac(
        electricity,
        cop,
        heating_load
    ){
        return heating_load / cop * electricity / 100;
    }

    calculateCosts();
</script>