# Imports packages
from datetime import datetime

# Calculates the total hours worked in a shift
def shift_calculate(shift_start, shift_end):
    shift_start = shift_start[12:]
    shift_end = shift_end[12:]
    difference = (datetime.strptime(shift_end, "%H:%M:%S") - datetime.strptime(shift_start, "%H:%M:%S")).total_seconds() / 3600
    return difference