SELECT json_agg(t)
FROM (
  SELECT
    p.hash_value,
    p.age,

    CASE p.sex
      WHEN 'M' THEN 'Male'
      WHEN 'F' THEN 'Female'
      ELSE 'Unknown'
    END AS sex,

    INITCAP(COALESCE(r.race_category, 'Unknown')) AS race,

    CASE b.category
      WHEN 'UNDERWEIGHT' THEN 'Underweight (<18.5)'
      WHEN 'NORMAL' THEN 'Normal (18.5-24.9)'
      WHEN 'OVERWEIGHT' THEN 'Overweight (25-29.9)'
      WHEN 'OBESE' THEN 'Obese (30+)'
      ELSE 'Unrecorded'
    END AS bmi_status,

    CASE d.category
      WHEN '2' THEN '0-2 Days'
      WHEN '7' THEN '3-7 Days'
      WHEN '30' THEN '8-30 Days'
      WHEN '180' THEN '31-180 Days'
      WHEN '365' THEN '181-365 Days'
      WHEN 'YEAR_PLUS' THEN '1+ Years'
      ELSE 'Uncategorized'
    END AS days_served_bins,

    p.days_left,

    CASE
      WHEN p.days_left IS NOT NULL THEN 'Date Logged'
      ELSE 'No Date (Null)'
    END AS release_date_status

  FROM pop_snap p
  LEFT JOIN race_lookup r ON p.race_lookup_id = r.lookup_id
  LEFT JOIN bmi_lookup b ON p.bmi_lookup_id = b.id
  LEFT JOIN days_served_bins d ON p.days_served_id = d.id
  ORDER BY random()
) t;
