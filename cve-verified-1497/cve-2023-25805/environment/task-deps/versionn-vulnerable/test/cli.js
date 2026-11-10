/**
 * versionn
 *
 * @copyright (C) 2016- commenthol
 * @license MIT
 */

'use strict'

/* global describe, it */

const assert = require('assert')
const cli = require('../lib/cli')

describe('#versionn cli', function () {
  it('no args', function () {
    const opts = cli([], [])
    assert.deepStrictEqual(opts, { files: [] })
  })
  it('--help', function () {
    const opts = cli(['--help'], [])
    assert.deepStrictEqual(opts, { help: true, files: [] })
  })
  it('-h', function () {
    const opts = cli(['-h'], [])
    assert.deepStrictEqual(opts, { help: true, files: [] })
  })
  it('--info', function () {
    const opts = cli(['--info'], [])
    assert.deepStrictEqual(opts, { info: true, files: [] })
  })
  it('-i', function () {
    const opts = cli(['-i'], [])
    assert.deepStrictEqual(opts, { info: true, files: [] })
  })
  it('--info --help', function () {
    const opts = cli(['--info', '--help'], [])
    assert.deepStrictEqual(opts, { help: true, info: true, files: [] })
  })
  it('--dir with missing param', function () {
    const opts = cli(['--dir'], [])
    assert.deepStrictEqual(opts, { dir: undefined, files: [] })
  })
  it('-d with param', function () {
    const opts = cli(['-d', '/tmp/dir'], [])
    assert.deepStrictEqual(opts, { dir: '/tmp/dir', files: [] })
  })
  it('--extract without param', function () {
    const opts = cli(['--extract'], [])
    assert.deepStrictEqual(opts, { extract: true, files: [] })
  })
  it('--extract with param', function () {
    const opts = cli(['--extract', './VERSION'], [])
    assert.deepStrictEqual(opts, { extract: './VERSION', files: [] })
  })
  it('--tag', function () {
    const opts = cli(['--tag'], [])
    assert.deepStrictEqual(opts, { tag: true, files: [] })
  })
  it('--untag', function () {
    const opts = cli(['--untag'], [])
    assert.deepStrictEqual(opts, { untag: true, files: [] })
  })
  it('--commit', function () {
    const opts = cli(['--commit'], [])
    assert.deepStrictEqual(opts, { commit: true, files: [] })
  })
  it('--version', function () {
    const opts = cli(['--version'], [])
    assert.deepStrictEqual(opts, { cliVersion: true, files: [] })
  })
  it('-V', function () {
    const opts = cli(['-V'], [])
    assert.deepStrictEqual(opts, { cliVersion: true, files: [] })
  })
})

describe('commands', function () {
  const CMDS = require('..').CMDS

  it('premajor', function () {
    const args = ['--premajor', 'package.json']
    const opts = cli(args.slice(), CMDS)
    assert.deepStrictEqual(opts, { cmd: 'premajor', files: [args[1]] })
  })
  it('same', function () {
    const args = ['same', 'package.json', 'VERSION']
    const opts = cli(args.slice(), CMDS)
    assert.deepStrictEqual(opts, { cmd: 'same', files: [args[1], args[2]] })
  })
  it('set', function () {
    const args = ['set', '1.0.0', 'package.json', 'VERSION']
    const opts = cli(args.slice(), CMDS)
    assert.deepStrictEqual(opts, { cmd: 'set', version: '1.0.0', files: [args[2], args[3]] })
  })
})
