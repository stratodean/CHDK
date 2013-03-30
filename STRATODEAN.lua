-- STRATODEAN Camera Control for CHDK written in Lua
--
--http://www.stratodean.co.uk
--
--Author: Mark Ireland

--[[
@title STRATODEAN Camera Control
@param s Interval (seconds)
@default s 10
@param d Initial Delay (seconds)
@default d 10
@param n FileNumber
@default n 1
@param c ScreenOff
@default c 0
]]
--Functions
--Get the date and time
function timeStamp()
    return string.format("%02d/%02d/%4d,%02d:%02d:%02d",
    get_time("D"),
	get_time("M"),
	get_time("Y"),
    get_time("h"),
    get_time("m"),
    get_time("s"))
end

--Get the time, iteration, temperatures and voltage and print it in a nice string
function logData(o)
	return string.format("%s,%i,%i,%i,%i",
	timeStamp(),
	o,
	get_temperature(0),
	get_temperature(1),
	get_vbatt())
end

--Setup
print_screen(n)
print("STRATODEAN Camera Control")
print(timeStamp())
print("Interval: ",s)
print("Initial Delay:",d)
print("File Number",n)

--Convert seconds into milliseconds and ensure that params are sensible
if s<5 then s=5 end
if d<1 then d=1 end
s = s*1000
d = d*1000

--Initial delay
sleep(d)

print("Starting picture capture")
print("Date,Time,Iteration,LensTemperature,CCDTemperature,BatteryVoltage")
i = 0

--endless loop for picture capture - will run until space full or battery empty
while(1) do
	--Take the picture
	shoot()	
	--Turn backlight off if set
	set_backlight(c)
	--Log the info to the file
	print(logData(i))
	--Add 1 to iteration
	i = i + 1
	--Sleep iteration delay
	sleep(s)	
end
