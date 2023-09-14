DELIMITER ;;
CREATE FUNCTION gregorian_to_jalali(gregorian_date date) RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
    DECLARE gregorian_year, gregorian_year2, gregorian_month, gregorian_day, days, jalali_year, jalali_month, jalali_day INT;
    SET gregorian_year = YEAR(gregorian_date);
    SET gregorian_month = MONTH(gregorian_date);
    SET gregorian_day = DAY(gregorian_date);
    SET gregorian_year2 = IF(gregorian_month>2, gregorian_year+1, gregorian_year);
    SET days = 355666 + (365 * gregorian_year) + FLOOR((gregorian_year2 + 3) / 4) - FLOOR((gregorian_year2 + 99) / 100) + FLOOR((gregorian_year2 + 399) / 400) + gregorian_day + ELT(gregorian_month, 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334);
    SET jalali_year = -1595 + (33 * FLOOR(days / 12053));
    SET days = MOD(days, 12053);
    SET jalali_year = jalali_year + 4 * FLOOR(days / 1461);
    set days = MOD(days, 1461);
    
    IF days > 365 THEN
        SET jalali_year = jalali_year + FLOOR((days - 1) / 365);
        SET days = MOD(days - 1, 365);
    END IF;
    IF days < 186 THEN
        SET jalali_month = 1 + FLOOR(days / 31);
        SET jalali_day = 1 + MOD(days, 31);
    ELSE
        SET jalali_month = 7 + FLOOR((days - 186) / 30);
        SET jalali_day = 1 + MOD(days - 186, 30);
    END IF;

    RETURN CONCAT_WS('/', jalali_year, jalali_month, jalali_day);
END;;
DELIMITER ;
