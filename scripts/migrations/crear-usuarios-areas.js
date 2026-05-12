const bcrypt = require('bcrypt');

async function hashPassword() {
  const password = process.env.SEED_DEFAULT_PASSWORD;

  if (!password) {
    console.error('Define SEED_DEFAULT_PASSWORD antes de generar hashes de usuarios seed.');
    process.exit(1);
  }

  const hash = await bcrypt.hash(password, 10);
  console.log('Hash bcrypt generado para SEED_DEFAULT_PASSWORD:');
  console.log(hash);
}

hashPassword();
