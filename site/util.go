package main

func Ok(err error) {
	if err != nil {
		panic(err)
	}
}

func Must[T any](val T, err error) T {
	Ok(err)
	return val
}
