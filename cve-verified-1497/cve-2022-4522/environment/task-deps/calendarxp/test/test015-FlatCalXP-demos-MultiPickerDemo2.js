
mocha.ui('bdd');
mocha.reporter('html');
var expect = chai.expect;

fixtures.path = '.';

var $ = window.jQuery;

describe('${FILENAME}', function () {

    // this.timeout(5000);

    beforeEach( function(done) {
        fixtures.clearCache()
        fixtures.cleanUp()
        fixtures.load('MultiPickerDemo2.htm', function() {
                // The body .. onload=".." handler gets parsed and executed by
                // the bare javascript engine after fixtures.js loads HTML with
                //      doc.open(); doc.write(html); doc.close();
                // Therefore the following load event dispatch seems redundant.
                // $(fixtures.window().document.body).trigger('load');
                setTimeout(done, 200);
            });
    } );

    var select = function(selector) {
            return $(selector, fixtures.window().document);
        };

    var selectInCalendar = function(prefix, selector) {
            return $(selector, select('iframe[name^="' + prefix + '"]').contents());
        };

    var clickCell = function(prefix, text, done) {
            var cellGetter = function() { 
                    return selectInCalendar(prefix, 'a.CellAnchor').filter(function() {
                            return (this.style.color == 'black') && (this.textContent == text);
                        });
                };
            var cell = cellGetter();
            expect(cell).to.have.lengthOf(1);
            cell.mouseover();
            setTimeout(function() {
                    var mousedownCell = cellGetter().mousedown();
                    setTimeout(function() {
                            var mouseupCell = cellGetter().mouseup();
                            setTimeout(function() {
                                    if (mouseupCell === mousedownCell) {
                                        cellGetter().click();
                                    } else {
                                        // console.log("Skipping the click event as browsers do when mousedown replaces the cell");
                                    }
                                    setTimeout(function() {
                                            cellGetter().mouseout();
                                            // cell seems to refer to a shadow copy of a DOM tree that will not
                                            // receive a refresh, so obtain the new jQuery object from the
                                            // refreshed DOM.
                                            setTimeout(function() {
                                                    done(cellGetter);
                                                }, 200);
                                        }, 200);
                                }, 200);
                        }, 200);
                }, 200);
        };

    var cellOp = function(prefix, text, op, done) {
            var cellGetter = function() { 
                    return selectInCalendar(prefix, 'a.CellAnchor').filter(function() {
                            return (this.style.color == 'black') && (this.textContent == text);
                        });
                };
            var cell = cellGetter();
            expect(cell).to.have.lengthOf(1);
            cell[op]();
            setTimeout(function() {
                    done(cellGetter);
                }, 200);
        };

    it('Choosing a date not marked by fInitAgenda in the first calendar', function(done) {
        clickCell('gToday', '3', function(cellGetter) {
                expect(cellGetter().parent().parent().attr("bgcolor")).to.equal('#fffacd');
                done();
            });
    });

    it('Choosing a date already marked by fInitAgenda in the first calendar', function(done) {
        var pds = fixtures.window().gfFlat_1.fGetPDS();
        expect(pds.length).to.equal(2);
        expect(new Date(pds[0][0]).getUTCDate()).to.equal(5);
        expect(new Date(pds[0][1]).getUTCDate()).to.equal(10);
        expect(new Date(pds[1][0]).getUTCDate()).to.equal(15);
        expect(new Date(pds[1][1]).getUTCDate()).to.equal(16);
        clickCell('gToday', '16', function(cellGetter) {
                // it's #e5e5e5 or white (if it's today) or skyblue (if it's a holiday)
                // expect(cellGetter().parent().parent().attr("bgcolor")).to.not.equal('#fffacd');
                expect(pds.length).to.equal(2);
                expect(new Date(pds[0][0]).getUTCDate()).to.equal(5);
                expect(new Date(pds[0][1]).getUTCDate()).to.equal(10);
                expect(new Date(pds[1][0]).getUTCDate()).to.equal(15);
                expect(new Date(pds[1][1]).getUTCDate()).to.equal(15);
                done();
            });
    });

    it('Choosing a date after clearing all dates', function(done) {
        select('input[value="Clear All"]').click();
        setTimeout(function() {
                clickCell('gToday', '16', function(cellGetter) {
                        expect(cellGetter().parent().parent().attr("bgcolor")).to.equal('#fffacd');
                        var pds = fixtures.window().gfFlat_1.fGetPDS();
                        expect(pds.length).to.equal(1);
                        expect(new Date(pds[0][0]).getUTCDate()).to.equal(16);
                        expect(new Date(pds[0][1]).getUTCDate()).to.equal(16);
                        done();
                    });
            }, 200);
    });

    it('Choosing a date range spanning two calendars', function(done) {
        select('input[value="Clear All"]').click();
        setTimeout(function() {
                cellOp('gToday', '17', 'mousedown', function(cellGetter) {
                        expect(cellGetter().parent().parent().attr("bgcolor")).to.equal('#fffacd');
                        cellOp('[gToday[0],', '2', 'mouseover', function(cellGetter2) {
                                cellOp('[gToday[0],', '2', 'mouseup', function(cellGetter2) {
                                        expect(cellGetter2().parent().parent().attr("bgcolor")).to.equal('#fffacd');
                                        var pds = fixtures.window().gfFlat_1.fGetPDS();
                                        expect(pds.length).to.equal(1);
                                        expect(new Date(pds[0][0]).getUTCDate()).to.equal(17);
                                        expect(new Date(pds[0][1]).getUTCDate()).to.equal(2);
                                        done();
                                    });
                            });
                    });
            }, 200);
    });
});

mocha.run();

