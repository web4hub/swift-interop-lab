for $user in (
  {"name": "Alice", "age": 21},
  {"name": "Bob", "age": 17},
  {"name": "Charlie", "age": 25}
)
where $user.age >= 18
return {
  "name": $user.name,
  "adult": true
}
