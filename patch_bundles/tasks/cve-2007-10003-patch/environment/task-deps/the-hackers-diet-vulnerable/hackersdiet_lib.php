<?
function convert_weights($old_unit, $new_unit) {
	// this function will take all weights in the system and convert them to the new units as well as recalculating the trend

}

function calories_per_unit($unit) {
	switch($unit) {
		case "kg":
			return round(3500 * 0.45359237);
		case "lb":
		default:
			return 3500;
	}
}

function hackdiet_get_options($user_id, $name="") {
	global $table_prefix;

	$options = array();

	if ($user_id > 0) {
		if ($name == "") {
			$query = "select name, value from ".$table_prefix."hackdiet_settings where wp_id = $user_id";
		} else {
			$query = "select name, value from ".$table_prefix."hackdiet_settings where wp_id = $user_id and name = '$name'";
		}

		$result = mysql_query($query) or die(mysql_error());
		while ($row = mysql_fetch_assoc($result)) {
			$options[$row["name"]] = $row["value"];
		}
	}

	return $options;
}

function hackdiet_save_options($user_id, $opt_arr) {
	global $table_prefix;

	$query = "select name, value from ".$table_prefix."hackdiet_settings where wp_id = $user_id";
	$result = mysql_query($query);
	if (mysql_num_rows($result)) {
		while ($row = mysql_fetch_assoc($result)) {
			$db[$row["name"]] = $row["value"];
		}

		foreach ($opt_arr as $opt_name => $opt_val) {
			$exists = false;
			$same = true;

			if (array_key_exists($opt_name, $db)) {
				if ($db[$opt_name] != $opt_val) {
					$query = "update ".$table_prefix."hackdiet_settings set value='$opt_val' where wp_id = $user_id and name='$opt_name'";
					mysql_query($query);
				}
			} else {
				$query = "insert into ".$table_prefix."hackdiet_settings (wp_id, name, value) values ($user_id, '$opt_name', '$opt_val')";
				mysql_query($query);
			}
		}
	} else {
		foreach ($opt_arr as $opt_name => $opt_val) {
			$query = "insert into ".$table_prefix."hackdiet_settings (wp_id, name, value) values ($user_id, '$opt_name', '$opt_val')";
			mysql_query($query);
		}
	}
}

// start   - yyyy-mm-dd
// end     - yyyy-mm-dd
function generate_stats($user_id, $start, $end, $unit="", $goal_weight=0, $goal_date="") {
	global $table_prefix;

	// TODO: make sure this code works for positive trends (aka gaining weight)

	$query = "select date, weight, trend from ".$table_prefix."hackdiet_weightlog where wp_id = $user_id and date >= '$start' and date <= '$end' order by date asc";
	$result = mysql_query($query);
	if (mysql_num_rows($result)) {
		while ($row = mysql_fetch_object($result)) {
			// min/max stuff
			if ($row->weight < $stats["min_weight"]) {
				$stats["min_weight"] = $row->weight;
			} else if (!$stats["min_weight"]) {
				$stats["min_weight"] = $row->weight;
			}
			if ($row->weight > $stats["max_weight"]) {
				$stats["max_weight"] = $row->weight;
			}
			if ($row->trend < $stats["min_trend"]) {
				$stats["min_trend"] = $row->trend;
			} else if (!$stats["min_trend"]) {
				$stats["min_trend"] = $row->trend;
			}
			if ($row->trend > $stats["max_trend"]) {
				$stats["max_trend"] = $row->trend;
			}

			// pack trends into an array for calcs
			$trends[] = $row->trend;
		}

		// calcs
		// y = mx + b for collection of data points $trends
		$n = count($trends);
		for ($i = 1; $i <= $n; $one += $i * $trends[$i-1], ++$i);
		for ($i = 1; $i <= $n; $two += $i, ++$i);
		for ($i = 1; $i <= $n; $three += $trends[$i-1], ++$i);
		for ($i = 1; $i <= $n; $four += pow($i, 2), ++$i);
		$num = ($n * $one) - ($two * $three);
		$denom = ($n * $four) - pow($two, 2);
		if ($denom != 0) {
			$m = $num / $denom;
		} else {
			$m = 0;
		}
		$stats["weekly_change"] = round(7 * $m, 1);
		$stats["daily_variance"] = round(calories_per_unit($unit) * $m);

		// only figure out if on_target if they supplied goals and there is more than one date
		if ($goal_weight && count($trends) > 1) {
			$to_go = $trends[count($trends)-1] - $goal_weight;
			$days_left = round($to_go / ($m * -1));

			if ($to_go < 0) {
				$stats["hit_goal"] = false;
			} else {
				$stats["hit_goal"] = true;
			}

			if ($goal_weight && !$goal_date) {
				// they only know what
				if ($days_left > 0) {
					// losing weight
					$stats["on_target"] = true; // if you dont have a target you can't miss it, right?
					$stats["new_date"] = date("Y-m-d", strtotime("now +$days_left days"));
				} else {
					// gaining weight
					$stats["on_target"] = false;
				}
			} else {
				// TODO: make sure that the goal date is in the future, otherwise return blanks since we can't compute
				// they know what and when
				$fantasy = strtotime($goal_date);
				$reality = strtotime("now +$days_left days");
				
				if ($days_left > 0) {
					$stats["new_date"] = date("Y-m-d", $reality);
				}

				$diff = abs($fantasy - $reality);

				if ($days_left > 0 and $reality <= $fantasy or $diff < (60 * 60 * 24)) {
					// ahead of schedule!
					$stats["on_target"] = true;
				} else {
					// you're slackin', fatboy!
					$stats["on_target"] = false;

					$most_recent_weight = $trends[count($trends)-1];
					$current_daily_loss_rate = ($m * -1);
					$days_until_goal = ($fantasy - strtotime("now")) / 60 / 60 / 24;

					// val = most recent weight - (current daily loss rate * days until goal)
					$weight_at_goal_date = $most_recent_weight - ($current_daily_loss_rate * $days_until_goal);
					// val = weight difference b/t goal and reality converted to calories
					$extra_cals_to_burn = ($weight_at_goal_date - $goal_weight) * calories_per_unit($unit);

					if ($days_until_goal != 0) {
						// val = extra calories spread evenly among days until goal
						$stats["extra_variance"] = round(($extra_cals_to_burn / $days_until_goal)) * -1;
					} else {
						$stats["extra_variance"] = 0;
					}

				}
			}
		}
	}

	return $stats;
}
?>